# XcodeGen

XcodeGen is a command line tool written in Swift that generates your Xcode project using your folder structure and a project spec.

- ✅ Generate projects on demand and remove your `.xcodeproj` from git, which means **no more merge conflicts**!



## Official

[XcodeGen](https://github.com/yonaskolb/XcodeGen)



## Installing

### Homebrew

```
$ brew install xcodegen
```



## Example - project.yml

```
name: MVVM-RxSwift-xcodegen
options:
  postGenCommand: pod install
settingGroups:
  app:
    DEVELOPMENT_TEAM: C2JSJLJ4FN
targets:
  MVVM-RxSwift-xcodegen:
    scheme:
      testTargets:
        - MVVM-RxSwift-xcodegenTests
    sources:
      excludes:
          - "SceneDelegate.swift"
    settings:
      groups: [app]
      base:
        INFOPLIST_FILE: MVVM-RxSwift-xcodegen/Info.plist
        PRODUCT_BUNDLE_IDENTIFIER: com.jeonggo.MVVM-RxSwift-xcodegen
    type: application
    platform: iOS
    deploymentTarget: 11.0
    sources: [MVVM-RxSwift-xcodegen]
    
  MVVM-RxSwift-xcodegenTests:
    type: bundle.unit-test
    platform: iOS
    sources: [MVVM-RxSwift-xcodegenTests]
    settings:
      groups: [app]
      INFOPLIST_FILE: Info.plist
      commandLineArguments: [run: true, test: true]
    dependencies:
      - target: MVVM-RxSwift-xcodegen
```

```
$ xcodegen
```

