//
//  JSLiveCameraPreviewView.m
//  CameraOverlay
//
//  Created by Javier Soto on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSLiveCameraPreviewView.h"

@interface JSLiveCameraPreviewView() <AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, retain) UIImageView *cameraImageView;
@property (nonatomic, retain) AVCaptureSession *captureSession;
@end

@implementation JSLiveCameraPreviewView

@synthesize cameraImageView = _cameraImageView;
@synthesize captureSession = _captureSession;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.cameraImageView = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
        _cameraImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _cameraImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_cameraImageView];
    }
    
    return self;
}

#pragma mark - Live Preview

- (AVCaptureSession *)captureSession
{
    if (!_captureSession)
    {
        self.captureSession = [[[AVCaptureSession alloc] init] autorelease];
        
        _captureSession.sessionPreset = AVCaptureSessionPreset640x480;
        
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        
        AVCaptureDevice *device = nil;
        
        for (AVCaptureDevice *d in devices)
        {
            if (d.position == AVCaptureDevicePositionBack)
            {
                device = d;
                break;
            }
        }
        
        if (device)
        {        
            AVCaptureDeviceInput *cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            if ([_captureSession canAddInput:cameraInput])
            {
                [_captureSession addInput:cameraInput];
                
                AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
                
                NSDictionary *options = [NSMutableDictionary dictionary];
                
                [options setValue:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(NSString *)kCVPixelBufferPixelFormatTypeKey];
                [options setValue:[NSNumber numberWithFloat:self.frame.size.width] forKey:(id)kCVPixelBufferWidthKey];
                [options setValue:[NSNumber numberWithFloat:self.frame.size.height] forKey:(id)kCVPixelBufferHeightKey];
                
                output.videoSettings = options;
                output.alwaysDiscardsLateVideoFrames = YES;
                
                dispatch_queue_t cameraStreamHandlingQueue = dispatch_queue_create("JSCameraStreamHandlingQueue", DISPATCH_QUEUE_SERIAL);
                
                [output setSampleBufferDelegate:self queue:cameraStreamHandlingQueue];
                dispatch_release(cameraStreamHandlingQueue);
                
                if ([_captureSession canAddOutput:output])
                {
                    [_captureSession addOutput:output];
                    
                    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
                    previewLayer.frame = self.bounds;
                    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                    
                    [self.layer addSublayer:previewLayer];
                    
                    [_captureSession startRunning];
                }
                else {
                    NSLog(@"Cant add camera output");
                }
            }
            else
            {
                NSLog(@"Cant add camera input");
            }
        }
        else {
            NSLog(@"No device found");
        }
    }
    
    return _captureSession;
}

- (void)startCameraCapture
{
    [self.captureSession startRunning];    
}

- (void)stopCameraCapture
{
    [_captureSession stopRunning];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate Methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CIFilter *filter = [self.filterToApply filter];
    
    if (filter)
    {    
        @autoreleasepool {
            
            CVPixelBufferRef pixel_buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixel_buffer];
            
            [filter setValue:ciImage forKey:@"inputImage"];
            
            CIImage *outputImage = filter.outputImage;
            
            CGImageRef ref = [self.context createCGImage:outputImage fromRect:outputImage.extent];
            UIImage *image = [UIImage imageWithCGImage:ref scale:1.0 orientation:connection.videoOrientation];
            
            CGImageRelease(ref);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.cameraImageView.image = image;
            });
        }    
    }
}

- (CIContext *)context
{
    static CIContext *_context = nil;
    
    if (!_context) {
        _context = [[CIContext contextWithOptions:nil] retain];
    }
    
    return _context;
}

#pragma mark - Memory Management

- (void)dealloc
{
    [_cameraImageView release];
    [_captureSession stopRunning];
    [_captureSession release];
    
    [_filterToApply release];
    
    [super dealloc];
}

@end
