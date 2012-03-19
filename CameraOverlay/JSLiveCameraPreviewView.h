//
//  JSLiveCameraPreviewView.h
//  CameraOverlay
//
//  Created by Javier Soto on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSBaseCameraImageFilter.h"

@interface JSLiveCameraPreviewView : UIView

/* Pass an instance of a class that conforms to the JSBaseCameraImageFilter protocol with a filter to apply in real time to the camera live stream */
@property (atomic, retain) id<JSBaseCameraImageFilter> filterToApply;

- (void)startCameraCapture;
- (void)stopCameraCapture;

@end
