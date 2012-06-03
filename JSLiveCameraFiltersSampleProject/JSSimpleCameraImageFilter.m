//
//  JSSimpleCameraImageFilter.m
//  CameraOverlay
//
//  Created by Javier Soto on 3/19/12.
//  Copyright (c) 2012 Javier Soto. All rights reserved.
//

#import "JSSimpleCameraImageFilter.h"

@interface JSSimpleCameraImageFilter()
@property (nonatomic, retain) CIFilter *filter;
@end

@implementation JSSimpleCameraImageFilter

@synthesize filter = _filter;

- (UIImage *)filteredImageFromOriginalCoreImageImage:(CIImage *)originalImage withOrientation:(UIImageOrientation)orientation
{
    [self.filter setValue:originalImage forKey:@"inputImage"];
    
    return UIImageFromCIImage(self.filter.outputImage, orientation);
}

- (CIFilter *)filter
{
    if (!_filter)
    {
        _filter = [[CIFilter filterWithName:@"CIToneCurve"] retain];
        [_filter setDefaults];
        [_filter setValue:[CIVector vectorWithX:25/255.0 Y:0] forKey:@"inputPoint1"];
        [_filter setValue:[CIVector vectorWithX:82/255.0 Y:27/255] forKey:@"inputPoint2"];
        [_filter setValue:[CIVector vectorWithX:187/255.0 Y:218/255.0] forKey:@"inputPoint3"];
    }
    
    return _filter;
}

- (void)dealloc
{
    [_filter release];
    
    [super dealloc];
}

@end
