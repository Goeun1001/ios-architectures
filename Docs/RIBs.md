# RIBs

## [Official](https://github.com/uber/RIBs)

![RIBs](https://github.com/uber/ribs/raw/assets/documentation/ribs.png)

### Interactor

An Interactor contains business logic. This is where you perform Rx subscriptions, make state-altering decisions, decide where to store what data, and decide what other RIBs should be attached as children.

All operations performed by the Interactor must be confined to its lifecycle. We have built tooling to ensure that business logic is only executed when the Interactor is active. This prevents scenarios where Interactors are deactivated, but subscriptions still fire and cause unwanted updates to the business logic or the UI state.

### Router

A Router listens to the Interactor and translates its outputs into attaching and detaching child RIBs. Routers exist for three simple reasons:

- Routers create an additional abstraction layer between a parent Interactor and its child Interactors. This makes synchronous communication between Interactors a tiny bit harder and encourages adoption of reactive communication instead of direct coupling between the RIBs.
- Routers contain simple and repetitive routing logic that would otherwise be implemented by the Interactors. Factoring out this boilerplate code helps to keep the Interactors small and more focused on the core business logic provided by the RIB.

### Builder

The Builder’s responsibility is to instantiate all the RIB’s constituent classes as well as the Builders for each of the RIB’s children.

Separating the class creation logic in the Builder adds support for mockability on iOS and makes the rest of the RIB code indifferent to the details of DI implementation. The Builder is the only part of the RIB that should be made aware of the DI system used in the project. By implementing a different Builder, it is possible to reuse the rest of the RIB code in a project using a different DI mechanism.

### Presenter

Presenters are stateless classes that translate business models into view models and vice versa. They can be used to facilitate testing of view model transformations. However, often this translation is so trivial that it doesn’t warrant the creation of a dedicated Presenter class. If the Presenter is omitted, translating the view models becomes a responsibility of a View(Controller) or an Interactor.

### View(Controller)

Views build and update the UI. This includes instantiating and laying out UI components, handling user interaction, filling UI components with data, and animations. Views are designed to be as “dumb” as possible. They just display information. In general, they do not contain any code that needs to be unit tested.

### Component

Components are used to manage the RIB dependencies. They assist the Builders with instantiating the other units that compose a RIB. The Components provide access to the external dependencies that are needed to build a RIB as well as own the dependencies created by the RIB itself and control access to them from the other RIBs. The Component of a parent RIB is usually injected into the child RIB's Builder to give the child access to the parent RIB's dependencies.

### RIB Tree

![State](https://github.com/uber/ribs/raw/assets/documentation/state.gif)

#### What is the difference between RIBs and MV*/VIPER?

MVC, MVP, MVI, MVVM and VIPER are architecture patterns. RIBs is a framework. What differentiates RIBs from frameworks based on MV*/VIPER is:

- **Business logic drives the app, not the view tree**. Unlike with MV*/VIPER, a RIB does not have to have a view. This means that the app hierarchy is driven by the business logic, not the view tree.
- **Independent business logic and view trees**. RIBs decouple how the business logic scopes are structured from view hierarchies. This allows the application to have a deep business logic tree, isolating business logic nodes, while maintaining a shallow view hierarchy making layouts, animations and transitions easy.



## 🙂 Advantages

- **Shared architecture across iOS and Android.** Build cross-platform apps that have similar architecture, enabling iOS and Android teams to cross-review business logic code.
- **Testability and Isolation.** Classes must be easy to unit test and reason about in isolation. Individual RIB classes have distinct responsibilities like: routing, business, view logic, creation. Plus, most RIB logic is decoupled from child RIB logic. This makes RIB classes easy to test and reason about independently.

## 🙁 Disadvantages





## Example - [RIBS + Rx](https://github.com/Goeun1001/ios-architectures/tree/master/RIBs-snapKit)

![RIBs](/Users/jge/Documents/dev/JGE-ios-architecture/Docs/images/RIBs.png)

AppDelegate

```swift
class AppComponent: Component<EmptyDependency>, RootDependency {
    init() {
        super.init(dependency: EmptyComponent())
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var launchRouter: LaunchRouting?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let launchRouter = RootBuilder(dependency: AppComponent()).build()
        self.launchRouter = launchRouter
        launchRouter.launch(from: window)
        return true
    }

}
```

RootBuilder

```swift
final class RootBuilder: Builder<RootDependency>, RootBuildable {
    
    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }
    
    func build() -> LaunchRouting {
        let viewController = RootViewController()
        let component = RootComponent(dependency: dependency, rootViewController: viewController)
        let interactor = RootInteractor(presenter: viewController)
        let tabbarBuilder = TabBarBuilder(dependency: component)
        return RootRouter(tabbarBuilder: tabbarBuilder, interactor: interactor, viewController: viewController)
    }
}
```

RootRouter

```swift
final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    // MARK: - Properties
    
    private let tabbarBuilder: TabBarBuildable

    // TODO: Constructor inject child builder protocols to allow building children.
    init(tabbarBuilder: TabBarBuildable, interactor: RootInteractable, viewController: RootViewControllable) {
        self.tabbarBuilder = tabbarBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: - Overridden: LaunchRouter
    
    override func didLoad() {
        super.didLoad()
        
        attachTabbarRIB()
    }
    
    // MARK: - Private methods
    
    private func attachTabbarRIB() {
        let router = tabbarBuilder.build(withListener: interactor)
        attachChild(router)
        viewController.pushViewController(router.viewControllable, animated: false)
    }
}
```

RootViewController

```swift
final class RootViewController: UINavigationController, RootPresentable, RootViewControllable {

    weak var listener: RootPresentableListener?

    func pushViewController(_ viewController: ViewControllable, animated: Bool) {
        self.navigationBar.isHidden = true
        pushViewController(viewController.uiviewController, animated: animated)
    }
}
```





## Good Examples

- [mathpresso](https://github.com/mathpresso) / [RIBsExample](https://github.com/mathpresso/RIBsExample)