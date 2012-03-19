//
//  JSCameraVC.m
//  CameraOverlay
//
//  Created by Javier Soto on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSCameraVC.h"

#import "JSLiveCameraPreviewView.h"

#import "CameraImageFilterSample.h"

@implementation JSCameraVC

- (void)loadView
{
    UIView *view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    view.backgroundColor = [UIColor grayColor];
    
    JSLiveCameraPreviewView *cameraPreview = [[JSLiveCameraPreviewView alloc] initWithFrame:view.bounds];
    
    CameraImageFilterSample *imageFilterSample = [[CameraImageFilterSample alloc] init];
    
    cameraPreview.filterToApply = imageFilterSample;
    [imageFilterSample release];
    
    [view addSubview:cameraPreview];
    
    [cameraPreview startCameraCapture];
    
    [cameraPreview release];
    
    self.view = view;
}

#pragma mark - Memory Management

@end
