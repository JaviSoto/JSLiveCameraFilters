#JSLiveCameraFilters v0.5.1

##Description:
```JSLiveCameraFilters``` gives you an easy to use UIView subclass ([```JSLiveCameraPreviewView```](https://github.com/JaviSoto/JSLiveCameraFilters/blob/master/JSLiveCameraFilters/JSLiveCameraPreviewView.h)) to implement a camera feed with real time filters using ```Core Image``` (iOS5+).

##How to use:

- Add a ```JSLiveCameraPreviewView``` view as a subview to one of your view controllers (like [```JSCameraVC```](https://github.com/JaviSoto/JSLiveCameraFilters/blob/master/JSLiveCameraFiltersSampleProject/JSCameraVC.m) in the sample app)
- Pass a filter to it via the ```filterToApply``` property. You have to use a class that conforms to the ```JSCameraImageFilter```, i.e. that implements this method:

```objc
- (UIImage *)filteredImageFromOriginalCoreImageImage:(CIImage *)originalImage withOrientation:(UIImageOrientation)orientation;
```
You can alter the ```originalImage``` object passed (e.g. using ```CIFilter```, check the sample filters) and returned the result as an ```UIImage```. You can use this function to get the ```UIImage``` from the ```CIImage```:

```objc
UIImage *UIImageFromCIImage(CIImage *ciimage, UIImageOrientation orientation);
```

##Status:
- This is kind of an unfinished prototype. But I hope it can be useful to get real time filters set up.
- The ```JSCameraImageFilterFaceDetector``` sample filter that I include in the sample project doesn't work, because I haven't had time to finish it :) If you want to contribute that would be great :)

##License:
Copyright 2012 [Javier Soto](http://twitter.com/javisoto) (ios@javisoto.es)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
 limitations under the License. 

Attribution is not required, but appreciated.

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/JaviSoto/jslivecamerafilters/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

