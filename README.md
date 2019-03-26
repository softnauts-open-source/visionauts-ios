# Visionauts
### This is a Visionauts an iOS Application Repository
Visionauts is an open source project created by Softnauts (https://www.softnauts.com/) to help visually impaired users. The project includes a mobile application for Android and iOS and a web application - CMS for managing beacons and their content.

The user, when moving around, receives information about his location based on beacons in his vicinity. The content of beacons must be configured in CMS. Every beacon must have an assigned information in CMS that will be read to the user by mobile application when he is near beacon. The application recognizes a specific beacon based on its uuid, minor and major.

The application should work with all beacons supporting the iBeacon standard. 
Visionauts uses default Core Location SDK for detecting beacons, however you can easily use any other services, i.e. https://kontakt.io/.

![ScreenShot](https://raw.githubusercontent.com/softnauts-open-source/visionauts-ios/master/sc1.png)
![ScreenShot](https://raw.githubusercontent.com/softnauts-open-source/visionauts-ios/master/sc2.png)
![ScreenShot](https://raw.githubusercontent.com/softnauts-open-source/visionauts-ios/master/sc3.png)

### I. How to use it
##### 1. Install library dependencies using CocoaPods
in system terminal use command:
```
pod install
```
[What is CocoaPods?](https://guides.cocoapods.org/using/getting-started.html)

##### 2. Open XCode project file _.xcworkspace_

##### 3. In _General_ project settings, select a team in Signing section
[More about teams and app signing](https://help.apple.com/xcode/mac/current/#/dev60b6fbbc7)

##### 4. Setup CMS API url :
```swift
//Networking service router
//BeaconsRouter.swift 
...
static let baseURL = "https://yourApiUrl.com" //replace with your api domain
...
```

##### 5. Setup Kontakt.io API KEY - optional step (instead of using default service) 
```swift
//AppDelegate.swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
...
Kontakt.setAPIKey("Your API key") // replace with your api key
...
}
```

##### 6. Setup custom text for "Help" screen in file _Localizable.strings_
```swift
"helpText" = "your help text";
```

##### 7. Run project on selected device

### II. Adding custom beacons SDK
1. Add SDK dependencies in the project.
2. Define the custom beacons service that conforms to protocol from _BeaconServiceAdapter.swift_
3. Create service provider on providers list in _ServiceFactory+BeaconServiceProvider.swift_
4. Add service in _ServiceFactory.swift_

There is an example implementation of custom beacons service:  _BeaconKontaktService_.
All beacons detections invokes method: foundBeacons(_ beacons: [CLBeacon]), provided by the beacon service.

### III. Custom modifications
The application gives ability to modify services and design in easy way. 
All services are defined in one file _ServicesFactory.swift_ which is the main interface.
Each service implements interface methods, so it can be exchanged just in one place and it can have its own implementation.

App structure is created using MVVM pattern which helps in testing and encapsulates business logic.

App navigation is managed by Coordinators and this makes it very flexible to navigate between view controllers.

App networking uses Router design pattern to maintain the routing and mocking api requests. 
[See routing requests](https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md#routing-requests)

### IV. Tech
Visionauts uses external libraries to work properly

| Library | description |
| ------ | ------ |
|[Alamofire] | - elegant networking library
| [Kingfisher]| - library for downloading and caching images from the web
| [Pulsator]| - pulse animation for iOS
| [KontaktSDK]| - library for Kontakt.io beacons

   [Alamofire]: <https://github.com/Alamofire/Alamofire>
   [Kingfisher]: <https://github.com/onevcat/Kingfisher>
   [Pulsator]: <https://github.com/shu223/Pulsator>
   [KontaktSDK]: <https://github.com/kontaktio/kontakt-ios-sdk>

### V. Authors

[![N|Solid](https://www.softnauts.com/assets/images/homepage/softnauts_logo_vertical.svg?v7)](https://www.softnauts.com/)

---

### VI. License

The MIT License

Copyright 2019 Softnauts

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---
**Free Software, Hell Yeah!**


