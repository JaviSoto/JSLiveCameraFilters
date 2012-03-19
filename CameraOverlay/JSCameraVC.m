//
//  JSCameraVC.m
//  CameraOverlay
//
//  Created by Javier Soto on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSCameraVC.h"

@interface JSCameraVC () <AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, retain) UIImageView *cameraImageView;
@end

@implementation JSCameraVC

- (void)loadView
{
    UIView *view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    view.backgroundColor = [UIColor grayColor];
    
    self.cameraImageView = [[[UIImageView alloc] initWithFrame:view.bounds] autorelease];
    _cameraImageView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:_cameraImageView];
    
    self.view = view;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startSession];
}

#pragma mark - Video Preview

- (void)startSession
{
    AVCaptureSession *session = [[[AVCaptureSession alloc] init] autorelease];
    session.sessionPreset = AVCaptureSessionPreset640x480;
    
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
        if ([session canAddInput:cameraInput])
        {
            [session addInput:cameraInput];
            
            AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
            
            NSDictionary *options = [NSMutableDictionary dictionary];
            
            [options setValue:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(NSString *)kCVPixelBufferPixelFormatTypeKey];
            [options setValue:[NSNumber numberWithFloat:self.view.frame.size.width] forKey:(id)kCVPixelBufferWidthKey];
            [options setValue:[NSNumber numberWithFloat:self.view.frame.size.height] forKey:(id)kCVPixelBufferHeightKey];
            
            output.videoSettings = options;
            output.alwaysDiscardsLateVideoFrames = YES;
            
            dispatch_queue_t cameraStreamHandlingQueue = dispatch_queue_create("CameraStreamHandlingQueue", DISPATCH_QUEUE_SERIAL);
            
            [output setSampleBufferDelegate:self queue:cameraStreamHandlingQueue];
            dispatch_release(cameraStreamHandlingQueue);
            
            if ([session canAddOutput:output])
            {
                [session addOutput:output];
                
                AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
//                previewLayer.frame = self.view.bounds;
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                
                [self.view.layer addSublayer:previewLayer];
                
                [session startRunning];
            }
            else {
                NSLog(@"Cant add camere a output");
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

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    @autoreleasepool {
    
        CVPixelBufferRef pixel_buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixel_buffer];
        
        CIFilter *filter = [CIFilter filterWithName:@"CIToneCurve"];    
        [filter setDefaults];
        [filter setValue:ciImage forKey:@"inputImage"];
        [filter setValue:[CIVector vectorWithX:25/255.0 Y:0] forKey:@"inputPoint1"];
        [filter setValue:[CIVector vectorWithX:82/255.0 Y:27/255] forKey:@"inputPoint2"];
        [filter setValue:[CIVector vectorWithX:187/255.0 Y:218/255.0] forKey:@"inputPoint3"];
        
        CIImage *outputImage = filter.outputImage;
        
        CGImageRef ref = [self.context createCGImage:outputImage fromRect:outputImage.extent];
        UIImage *image = [UIImage imageWithCGImage:ref scale:1.0 orientation:connection.videoOrientation];
        
        CGImageRelease(ref);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.cameraImageView.image = image;
        });
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
    
    [super dealloc];
}

@end
