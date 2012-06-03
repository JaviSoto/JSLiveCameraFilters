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

#import "JSCameraImageFilterUtils.h"

@protocol JSCameraImageFilter <NSObject>

/* Implement this method to return the image after applying the wanted filters to originalImage. Use the util method UIImageFromCIImage to return the UIImage from the outputImage of the CIImage */
- (UIImage *)filteredImageFromOriginalCoreImageImage:(CIImage *)originalImage withOrientation:(UIImageOrientation)orientation;
@end
