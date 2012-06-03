//
//  JSCameraImageFilterFaceDetector.m
//  LiveFilters
//
//  Created by Javier Soto on 3/20/12.
//  Copyright (c) 2012 Javier Soto. All rights reserved.
//

#import "JSCameraImageFilterFaceDetector.h"

static CIDetector *detector = nil;

@implementation JSCameraImageFilterFaceDetector

- (UIImage *)filteredImageFromOriginalCoreImageImage:(CIImage *)originalImage withOrientation:(UIImageOrientation)orientation
{
    if (detector == nil)
        detector = [[CIDetector detectorOfType:CIDetectorTypeFace context:nil options:[NSDictionary dictionaryWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil]] retain];
    
    NSArray *features = [detector featuresInImage:originalImage options:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:[self currentDeviceEXIFOrientation]] forKey:CIDetectorImageOrientation]];
    
    UIImage *image = UIImageFromCIImage(originalImage, orientation);
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    
	UIGraphicsPushContext(ctx);
    {
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        
        for (CIFeature *f in features)
        {
            CGRect b = f.bounds;
            
            NSLog(@"%@", NSStringFromCGRect(b));
            
//            CGContextSetFillColorWithColor(ctx, );
            CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5f].CGColor);
            CGContextStrokeRectWithWidth(ctx, b, 2);
        }
    }
	UIGraphicsPopContext();

	UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (int)currentDeviceEXIFOrientation
{
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
	int exifOrientation;
    
    BOOL isUsingFrontFacingCamera = YES;

	enum {
		PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
		PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2, //   2  =  0th row is at the top, and 0th column is on the right.  
		PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.  
		PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.  
		PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.  
		PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.  
		PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.  
		PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.  
	};
	
	switch (curDeviceOrientation) {
		case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
			exifOrientation = PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
			break;
		case UIDeviceOrientationLandscapeLeft:       // Device oriented horizontally, home button on the right
			if (isUsingFrontFacingCamera)
				exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
			else
				exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
			break;
		case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
			if (isUsingFrontFacingCamera)
				exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
			else
				exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
			break;
		case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
		default:
			exifOrientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
			break;
	}
    
    return exifOrientation;
}

@end
