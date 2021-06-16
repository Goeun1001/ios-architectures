# Tuist

Tuist is a tool to manage Xcode projects similar to XcodeGen.

XcodeGen manages project settings with YAML and all corresponding values must be entered as strings. But Tuist manages settings with a Swift file called **Project.swift** and supports auto-complete.



## Official

- [Tuist](https://github.com/tuist/tuist)

## Installing

### Homebrew

```
$ bash <(curl -Ls https://install.tuist.io)
```



## Example - Project.swift

```swift
import ProjectDescription

let project = Project(
    name: "MVVM-RxSwift-tuist",
    targets: [
        Target(
            name: "MVVM-RxSwift-tuist",
            platform: .iOS,
            product: .app,
            bundleId: "com.jeonggo.MVVM-RxSwift-tuist",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
            infoPlist: "Sources/Info.plist",
            sources: ["Sources/**"],
            resources: ["Sources/View/UI/Base.lproj/*", "Sources/View/UI/xibs/BeerTableViewCell.xib", "Sources/Stub.bundle"],
            dependencies: [
                .cocoapods(path: ".")
            ]
        ),
        Target(
            name: "MVVM-RxSwift-tuistTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.jeonggo.MVVM-RxSwift-tuistTests",
            infoPlist: "Tests/Info.plist",
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "MVVM-RxSwift-tuist"),
                .cocoapods(path: ".")
            ]
        )
    ]
)
```

