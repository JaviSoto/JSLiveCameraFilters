//
//  JSBaseCameraImageFilter.h
//  CameraOverlay
//
//  Created by Javier Soto on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSCameraImageFilterUtils.h"

@protocol JSCameraImageFilter <NSObject>

/* Implement this method to return the image after applying the wanted filters to originalImage. Use the util method UIImageFromCIImage to return the UIImage from the outputImage of the CIImage */
- (UIImage *)filteredImageFromOriginalCoreImageImage:(CIImage *)originalImage withOrientation:(UIImageOrientation)orientation;
@end
