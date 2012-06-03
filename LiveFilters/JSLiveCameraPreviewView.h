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

#import "JSBaseCameraImageFilter.h"

/* Yoy need to link against all these frameworks */
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreImage/CoreImage.h>
#import <CoreVideo/CoreVideo.h>

@interface JSLiveCameraPreviewView : UIView

/* Pass an instance of a class that conforms to the JSCameraImageFilter protocol with a filter to apply in real time to the camera live stream */
@property (atomic, retain) id<JSCameraImageFilter> filterToApply;

- (void)startCameraCapture;
- (void)stopCameraCapture;

@end
