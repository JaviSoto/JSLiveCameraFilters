//
//  JSCameraImageFilterUtils.m
//  LiveFilters
//
//  Created by Javier Soto on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

static CIContext *_coreImageContext = nil;

UIImage *UIImageFromCIImage(CIImage *ciimage, UIImageOrientation orientation)
{
    if (!_coreImageContext)
    {
        _coreImageContext = [[CIContext contextWithOptions:nil] retain];
    }
    
    CGImageRef cgImage = [_coreImageContext createCGImage:ciimage fromRect:ciimage.extent];
    
    UIImage *filteredImage = [UIImage imageWithCGImage:cgImage scale:1.0 orientation:orientation];
    
    CGImageRelease(cgImage);
    
    return filteredImage;
}
