# Package managements

## 1. Cocoapod

### [Official](https://cocoapods.org/)

CocoaPods works well with objective c and swift. This is mostly used swift package manger.

CocoaPods automate the entire process of building, linking the dependency to targets.



### Installing

```null
$ sudo gem install cocoapods 
```

```
$ pod init
$ pod install
```



### 🙂 Advantages

- It’s easy to add/remove any external framework using CocoaPods
- CocoaPods automate the entire process of building, linking the dependency to targets

### 🙁 Disadvantages

- Slow down the app build process and It is centralised.



### [Example - Podfile](https://github.com/Goeun1001/ios-architectures/tree/master/Package-managements/CocoaPods)

```
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MVVM-RxSwift-storyboard' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MVVM-RxSwift-storyboard
    pod 'RxSwift', '~> 5'
    pod 'RxCocoa', '~> 5'
    pod 'RxDataSources', '~> 4.0'

    pod 'Kingfisher', '~> 6.0'

    target 'MVVM-RxSwift-storyboardTests' do
      pod 'RxSwift', '~> 5'

      # Test
      pod 'RxTest', '~> 5'
    end

end
```





## 2. Swift Package Manager(SPM)

### [Official](https://swift.org/package-manager/)

Due to Xcode 11 and above, apple provides a way to install swift packages directly into your project.

SPM automate the entire process of building, linking the dependency to targets.



### 🙂 Advantages

- It’s build by Apple to create Swift apps.
- If a dependency relies on another dependency, Swift Package Manager will handle it for you.
- It can be easily integrated with Continuous Integration server



### 🙁 Disadvantages

- It is compatible with Swift 5 and Xcode 11



### [Example](https://github.com/Goeun1001/ios-architectures/tree/master/Package-managements/SPM)



## 3. Carthage

### [Official](https://github.com/Carthage/Carthage)

It builds framework binaries using `xcodebuild` but user needs to integrate those libraries into project.



### Installing

```
$ brew install carthage
```

```
$ touch Cartfile
$ carthage update
```



### 🙂 Advantages

- App build process is fast and It is decentralised.
- It will not change any project structure.



### 🙁 Disadvantages

- It requires too many manual steps to integrate the framework.
- Not have many contributor.
- Carthage only works with dynamic frameworks. It doesn’t work with static libraries.



### [Example - Cartfile](https://github.com/Goeun1001/ios-architectures/tree/master/Package-managements/Carthage)

```
github "ReactiveX/RxSwift" ~> 5.0.0
github "RxSwiftCommunity/RxDataSources" ~> 4.0
github "onevcat/Kingfisher" ~> 6.0
```



### Using Carthage with Xcode 12

You have to use below './carthage.sh'

```
# carthage.sh
# Usage example: ./carthage.sh build --platform iOS

set -euo pipefail

xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXX)
trap 'rm -f "$xcconfig"' INT TERM HUP EXIT

# For Xcode 12 make sure EXCLUDED_ARCHS is set to arm architectures otherwise
# the build will fail on lipo due to duplicate architectures.

CURRENT_XCODE_VERSION=$(xcodebuild -version | grep "Build version" | cut -d' ' -f3)
echo "EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200__BUILD_$CURRENT_XCODE_VERSION = arm64 arm64e armv7 armv7s armv6 armv8" >> $xcconfig

echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200 = $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200__BUILD_$(XCODE_PRODUCT_BUILD_VERSION))' >> $xcconfig
echo 'EXCLUDED_ARCHS = $(inherited) $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_$(EFFECTIVE_PLATFORM_SUFFIX)__NATIVE_ARCH_64_BIT_$(NATIVE_ARCH_64_BIT)__XCODE_$(XCODE_VERSION_MAJOR))' >> $xcconfig

export XCODE_XCCONFIG_FILE="$xcconfig"
carthage "$@"
```

```
$ chmod +x carthage.sh
$ ./carthage.sh update --platform iOS
```



## 3-1. Rome

### [Official](https://github.com/tmspzz/Rome)

Rome is a cache tool for Carthage. 

It means it can download already built dependencies so that Carthage doesn't have to compile them.



### Installing

```
$ brew tap tmspzz/tap https://github.com/tmspzz/homebrew-tap.git
$ brew install tmspzz/homebrew-tap/rome
```

```
$ vi Cartfile
```

```
$ carthage update && rome upload
```

```
$ carthage update --no-build && rome download
```



### 🙂 Advantages

- faster CI builds,
- faster checkout builds on developer’s machines.



### [Example - Romefile](https://github.com/Goeun1001/ios-architectures/tree/master/Package-managements/Carthage)

```
cache: # required
  # at least one of the following is required:
  s3Bucket: beer-carthage-bucket
                    
repositoryMap: # optional
  - RxSwift:
     - name: RxSwift
     - name: RxCocoa
     - name: RxBlocking
     - name: RxRelay
     - name: RxTest
  - RxDataSources:
    - name: RxDataSources
    - name: Differentiator

```



## 3-2. Carting

### [Official](https://github.com/artemnovichkov/Carting)

It scans Carthage folder and linked frameworks, gets framework names and updates the script.



### Installing

```
$ brew tap artemnovichkov/projects
$ brew install carting
```

```
$ carting update
```



### 🙂 Advantages

- After linking the framework to the project and performing carting update, Carting scans the Carthage folder and linked frameworks and automatically creates the input files of the run script that does /usr/local/bin/carthage copy-frameworks.



## 3-3. Fastlane

### [Official](https://github.com/fastlane/fastlane)



### 🙂 Advantages

- With fastlane, you can run multiple commands into a single command line.



### Example - Fastfile

```
default_platform(:ios)

platform :ios do
  desc "Description of what the lane does"
  lane :push do
    rome(
    command: "upload",
    platform: "iOS",
    concurrently: "true",
    )
     sh("cd ..;carting update")
  end

  lane :pull do
    rome(
      command: "download",
      platform: "iOS",
      concurrently: "true"
    )
    sh("cd ..;carting update")
  end
end
```

### - Pluginfile

```
gem 'fastlane-plugin-rome'
```





### Reference

- [CocoaPods vs Carthage vs SPM (Dependency manager in Swift)](https://manasaprema04.medium.com/dependency-managers-in-swift-d6a01e7a29a8)