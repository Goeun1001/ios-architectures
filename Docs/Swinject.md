# Swinject

What is Dependench Injection in Swift? -> [Dependency Injection Framework for Swift - Introduction to Swinject](https://yoichitgy.github.io/post/dependency-injection-framework-for-swift-introduction-to-swinject/)

## [Official](https://github.com/Swinject/Swinject)

----

[Swinject](https://github.com/Swinject/Swinject) is a lightweight dependency injection framework written in Swift to use with Swift. The framework APIs are easy to learn and use because of the generic type and first class function features of Swift. Swinject is available through [CocoaPods](https://cocoapods.org/) or [Carthage](https://github.com/Carthage/Carthage).

There are several places in the app that create and inject instances outside. In other words, the locations where instances are created are distributed.

But let's assume that a **Container** has all instances and manages them all. Container has Register and Resolve functions.

**Register**: Create and register all instances that I will use in the future in the container

**Resolve**: When you ask the container for an instance of a specific type when you need it, which the container takes out.

```swift
private let container = Container()

container.register(A.self) // Create Instance
container.register(B.self)

let a = container.resolve(A.self)! // Get Instance
let b = container.resolve(B.self)!
```

Let's create a simple container.

```swift
class DIContainer {
    static let shared = DIContainer()
    private var dependencies = [String: Any]()
   
    func register<T>(_ dependency: T) {
        let key = String(describing: type(of: T.self))
        dependencies[key] = dependency
    }
    
    func resolve<T>() -> T {
        let key = String(describing: type(of: T.self))
        let dependency = dependencies[key]
        
        precondition(dependency != nil, "No Dependency found for - \(key).")
        
        return dependency as! T
    }
}
```

To use this more concisely, let's create a propertywrapper.

```swift
@propertyWrapper
class Dependency<T> {
    
    let wrappedValue: T
    
    init() {
        self.wrappedValue = DIContainer.shared.resolve()
    }
}
```



## Example - [Container+RegisterDependencies.swift](https://github.com/Goeun1001/ios-architectures/tree/master/Clean-RxFlow-Swinject)

```swift
 func registerRepositories() {
        autoregister(BeerListRepository.self, initializer: DefaultBeerListRepository.init)
        autoregister(RandomBeerRepository.self, initializer: DefaultRandomBeerRepository.init)
        autoregister(SearchBeerRepository.self, initializer: DefaultSearchBeerRepository.init)
    }
```

### - [SwinjectAutoregistration](https://github.com/Swinject/SwinjectAutoregistration)

### Registration

where PetOwner looks like this:

```swift
class PetOwner: Person {
    let pet: Animal

    init(pet: Animal) {
        self.pet = pet
    }
}
```

Here is a simple example to auto-register a pet owner

```swift
let container = Container()
container.register(Animal.self) { _ in Cat(name: "Mimi") } // Regular register method
container.autoregister(Person.self, initializer: PetOwner.init) // Autoregistration
```



## Reference

- [Dependency Injection Framework for Swift - Introduction to Swinject](https://yoichitgy.github.io/post/dependency-injection-framework-for-swift-introduction-to-swinject/)
- [Dependency Container in iOS Swift + Property Wrappers](https://www.youtube.com/watch?v=h2FBZcLBeq0)

