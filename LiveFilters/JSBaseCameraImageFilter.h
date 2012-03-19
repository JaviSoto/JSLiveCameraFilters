//
//  JSBaseCameraImageFilter.h
//  CameraOverlay
//
//  Created by Javier Soto on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@protocol JSBaseCameraImageFilter <NSObject>
/* Implement this method and return a CIFilter instance to apply to the live stream of a JSLiveCameraPreviewView instance */
/* See http://developer.apple.com/library/mac/#documentation/graphicsimaging/reference/CoreImageFilterReference/Reference/reference.html on how to implement the filters */
- (CIFilter *)filter;
@end
