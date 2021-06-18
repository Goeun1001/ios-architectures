# iOS Architectures

## Docs

- [Docs](https://github.com/Goeun1001/ios-architectures/tree/master/Docs)



## API

- [Beer API](https://punkapi.com/documentation/v2)



## Reference

1. Started from [Pawel Krawiec](https://github.com/tailec)'s [ios-architecture](https://github.com/tailec/ios-architecture) & [Bo-Young PARK](https://github.com/fimuxd)'s [BringMyOwnBeer-](https://github.com/fimuxd/BringMyOwnBeer-)
2. Studied MVVM+RxSwift with [Miguel Lin](https://github.com/gannasong)'s [RxSwift-MVVM-Demo](https://github.com/gannasong/RxSwift-MVVM-Demo)
3. Studied Coodinator Pattern with [wojciech-kulik](https://github.com/wojciech-kulik)'s [Swift-MVVMC-Demo](https://github.com/wojciech-kulik/Swift-MVVMC-Demo)
4. Studied Clean Architecture with [Oleh](https://github.com/kudoleh)'s [iOS-Clean-Architecture-MVVM](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)

Thank for people of this list!



## Screenshots

| List | Search | Random |
| :--: | :----: | :----: |
<img src = "./screenshots/1.png" width = 400> | <img src = "./screenshots/2.png" width = 400> | <img src = "./screenshots/3.png" width = 400> |



## Concept

1. [Objc](#1-objc-mvc)
2. [Swift](#1-mvc---storyboard)
3. [SwiftUI](#1-swiftui--mv)



### Environment

Swift 5, Xcode 12.5, SwiftUI1.0 (Support iOS 13)



## 0. Shared

Image Download - Kingfisher

Package Management - Cocoapods

````
$ pod install
````



## 1. [Objc-MVC](https://github.com/Goeun1001/ios-architectures/tree/master/Objc-MVC)

UI - Storyboard

Image - NSCache

Network - NSData to Json



## 1. [MVC - storyboard](https://github.com/Goeun1001/ios-architectures/tree/master/MVC-storyboard)

UI - Storyboard

Network - URLSession



## 2. [MVC - snapKit](https://github.com/Goeun1001/ios-architectures/tree/master/MVC-snapKit)

UI - SnapKit

Network - URLSession



## 3. [MVP - snapKit](https://github.com/Goeun1001/ios-architectures/tree/master/MVP-snapKit)

UI - SnapKit, Then

Network - URLSession



## 4. [MVVM - RxSwift - storyboard](https://github.com/Goeun1001/ios-architectures/tree/master/MVVM-RxSwift-storyboard)

UI - Storyboard, RxDatasource

Network - RxURLSession

Unit Tests 👌 - RxTest



## 4-1. [MVVM - RxSwift - xcodegen](https://github.com/Goeun1001/ios-architectures/tree/master/MVVM-RxSwift-xcodegen)

UI - Storyboard, RxDatasource

Network - RxURLSession

Unit Tests 👌 - RxTest

Xcodegen 👌

```
$ brew install xcodegen
```

```
$ cd MVVM-RxSwift-xcodegen/
$ xcodegen
```



## 4-2. [MVVM - RxSwift - tuist](https://github.com/Goeun1001/ios-architectures/tree/master/MVVM-RxSwift-tuist)

UI - Storyboard, RxDatasource

Network - RxURLSession

Unit Tests 👌 - RxTest

Tuist 👌

```
$ bash <(curl -Ls https://install.tuist.io)
```

```
$ cd MVVM-RxSwift-tuist/
$ tuist generate
```



## 4-3. [CocoaPods, SPM, Carthage + Rome](https://github.com/Goeun1001/ios-architectures/tree/master/Package-managements)

[MVVM - RxSwift - storyboard](#4-mvvm---rxswift---storyboard)'s 

[CocoaPods(original)](https://github.com/Goeun1001/ios-architectures/tree/master/Package-managements/CocoaPods),

[SPM](https://github.com/Goeun1001/ios-architectures/tree/master/Package-managements/SPM),

[Carthage](https://github.com/Goeun1001/ios-architectures/tree/master/Package-managements/Carthage)

- Rome, Carting, Fastlane

```
$ chmod +x carthage.sh
$ ./carthage.sh update --platform iOS
```

Reference

- [.carthage.sh](https://github.com/Carthage/Carthage/blob/master/Documentation/Xcode12Workaround.md)
- [fastlane-plugin-rome](https://github.com/OpenShelter/fastlane-plugin-rome)
- [Rome + Carthage = Build Your Dependencies Faster](https://www.netguru.com/codestories/rome-carthage-build-your-dependencies-faster)



## 5. [MVVM - RxSwift - snapKit](https://github.com/Goeun1001/ios-architectures/tree/master/MVVM-RxSwift-snapKit)

UI - SnapKit, Then, RxDatasource

Network - Moya

Unit Tests 👌 - RxTest



## 5-1. [MVVM - RxSwift - coreData](https://github.com/Goeun1001/ios-architectures/tree/master/MVVM-RxSwift-coreData)

UI - SnapKit, Then, RxDatasource

Network - RxURLSession

Repositoy Pattern - CoreData

Unit Tests 👌 - RxTest, Nimble



## 5-2. [MVVM - RxSwift - realm](https://github.com/Goeun1001/ios-architectures/tree/master/MVVM-RxSwift-realm)

UI - SnapKit, Then, RxDatasource

Network - RxURLSession

Repositoy Pattern - Realm

Unit Tests 👌 - RxTest, Nimble



## 5-3. [MVVM - RxSwift - sqlite](https://github.com/Goeun1001/ios-architectures/tree/master/MVVM-RxSwift-sqlite)

UI - SnapKit, Then, RxDatasource

Network - RxURLSession

Repositoy Pattern - Sqlite3

Unit Tests 👌 - RxTest, Nimble



## 5-4. [Clean Architecture - MVVM - RxSwift - coredata](https://github.com/Goeun1001/ios-architectures/tree/master/Clean-MVVM)

5-1. [MVVM - RxSwift - coreData](https://github.com/Goeun1001/ios-architectures/tree/master/MVVM-RxSwift-coreData) to Clean Architecture



## 6. [MVVM-C - RxSwift](https://github.com/Goeun1001/ios-architectures/tree/master/MVVM-C-RxSwift)

UI - SnapKit, Then, RxDatasource

Network - Moya

Unit Tests 👌 - RxTest, Nimble, Quick

CI - Github Actions 👌



## 6-1. [MVVM-C - RxSwift - Swinject](https://github.com/Goeun1001/ios-architectures/tree/master/MVVM-C-RxSwift-swinject)

UI - SnapKit, Then, RxDatasource

Network - Moya

Unit Tests 👌 - RxTest, Nimble, Quick

CI - Github Actions 👌

DI - Swinject



## 7. [MVVM - RxSwift - RxFlow](https://github.com/Goeun1001/ios-architectures/tree/master/MVVM-RxSwift-rxflow)

UI - SnapKit, Then, RxDatasource

Network - Moya

Unit Tests 👌 - RxTest



## 7-1. [Clean Architecture - RxFlow - Swinject](https://github.com/Goeun1001/ios-architectures/tree/master/Clean-RxFlow-Swinject)

7. [MVVM - RxSwift - RxFlow](https://github.com/Goeun1001/ios-architectures/tree/master/MVVM-RxSwift-rxflow) to Clean Architecture

DI - Swinject



## 8. [ReactorKit - RxFlow](https://github.com/Goeun1001/ios-architectures/tree/master/ReactorKit-RxFlow)

UI - SnapKit, Then, RxDatasource

Network - Moya

Unit Tests 👌



## 9. [VIPER + Rx](https://github.com/Goeun1001/ios-architectures/tree/master/VIPER-snapKit)

UI - SnapKit, Then, RxDatasource

Network - Moya

Unit Tests 👌 - RxTest

VIPER Template - [VIPER + Rx Xcode Template](https://github.com/Goeun1001/VIPER-Rx-Template)



## 10. [RIBs + Rx](https://github.com/Goeun1001/ios-architectures/tree/master/RIBs-snapKit)

Package Management - SPM

UI - SnapKit, Then, RxDatasources

Network - Moya

Unit Tests 👌

Reference

- [Unit Test 작성하기](http://minsone.github.io/programming/swift-ribs-unit-test)



## 1. [SwiftUI- MV](https://github.com/Goeun1001/ios-architectures/tree/master/SwiftUI-MV)

Using @State only

Network - Moya



## 2. [SwiftUI-MVVM](https://github.com/Goeun1001/ios-architectures/tree/master/SwiftUI-MVVM)

Using @Published

Network - Moya

Unit Tests 👌



## 3. [SwiftUI-MVVM-Combine](https://github.com/Goeun1001/ios-architectures/tree/master/SwiftUI-MVVM-Combine)

Using Combine's PassthroughSubject

Network - Moya

Unit Tests 👌



## 3-1. [Clean Architecture - MVVM - Combine](https://github.com/Goeun1001/ios-architectures/tree/master/SwiftUI-Clean)

Using Combine's PassthroughSubject

Network - Moya

Unit Tests 👌



## 3-2. SwiftUI - Coordinator





## 4. SwiftUI 2.0

3. [SwiftUI-MVVM-Combine](https://github.com/Goeun1001/ios-architectures/tree/master/SwiftUI-MVVM-Combine)'s SwiftUI 2.0

Used 

```swift
 ScrollView {
      LazyVStack {
```

Instead of

```swift
List {
```

Used

```swift
if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2.0, anchor: .center)
                }
```

Instead of

```swift
ActivityIndicator(isAnimating: $viewModel.isLoading, style: .large)
```



## 💕 WAITING YOUR PR for the better codes.