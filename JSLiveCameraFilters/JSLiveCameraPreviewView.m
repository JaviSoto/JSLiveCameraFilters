/* 
 Copyright 2012 Javier Soto (ios@javisoto.es)
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License. 
 */

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
        [_captureSession beginConfiguration];
        
        // Modify if needed to adjust for the size of the view (for perfomance reasons)
        _captureSession.sessionPreset = AVCaptureSessionPreset640x480;
        
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        
        AVCaptureDevice *device = nil;
        
        for (AVCaptureDevice *d in devices)
        {
            // Modify if needed to use other cameras
            if (d.position != AVCaptureDevicePositionFront)
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
                
                dispatch_queue_t cameraStreamHandlingQueue = dispatch_queue_create("es.javisoto.livecamerapreviewview.streamqueue", DISPATCH_QUEUE_SERIAL);
                
                [output setSampleBufferDelegate:self queue:cameraStreamHandlingQueue];
                dispatch_release(cameraStreamHandlingQueue);
                
                if ([_captureSession canAddOutput:output])
                {
                    [_captureSession addOutput:output];
                    
                    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
                    previewLayer.frame = self.bounds;
                    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                    
                    [self.layer insertSublayer:previewLayer below:self.cameraImageView.layer];
                }
                else
                {
                    NSAssert(NO, @"Cant add camera output");
                }
            }
            else
            {
                NSAssert(NO, @"Cant add camera input");
            }
        }
        else
        {
            NSAssert(NO, @"No device found");
        }
        
        [_captureSession commitConfiguration];
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
    @autoreleasepool {
        CVPixelBufferRef pixel_buffer   = CMSampleBufferGetImageBuffer(sampleBuffer);
        CFDictionaryRef attachments     = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
        
        CIImage *ciImage                = [[CIImage alloc] initWithCVPixelBuffer:pixel_buffer options:(NSDictionary *)attachments];
        
        if (attachments)
            CFRelease(attachments);
        
        UIImage *filteredImage          = [self.filterToApply filteredImageFromOriginalCoreImageImage:ciImage withOrientation:connection.videoOrientation];
        
        [ciImage release];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.cameraImageView.image = filteredImage;
        });
    }
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
