# RxFlow



## [Official](https://github.com/RxSwiftCommunity/RxFlow)

There are 6 terms you have to be familiar with to understand **RxFlow**:

- **Flow**: each **Flow** defines a navigation area in your application. This is the place where you declare the navigation actions (such as presenting a UIViewController or another **Flow**).
- **Step**: a **Step** is a way to express a state that can lead to a navigation. Combinations of **Flows** and **Steps** describe all the possible navigation actions. A **Step** can even embed inner values (such as Ids, URLs, ...) that will be propagated to screens declared in the **Flows**
- **Stepper**: a **Stepper** can be anything that can emit **Steps** inside **Flows**.
- **Presentable**: it is an abstraction of something that can be presented (basically **UIViewController** and **Flow** are **Presentable**).
- **FlowContributor**: it is a simple data structure that tells the **FlowCoordinator** what will be the next things that can emit new **Steps** in a **Flow**.
- **FlowCoordinator**: once the developer has defined the suitable combinations of **Flows** and **Steps** representing the navigation possibilities, the job of the **FlowCoordinator** is to mix these combinations to handle all the navigation of your app. **FlowCoordinators** are provided by **RxFlow**, you don't have to implement them.



## [Sample](https://github.com/Goeun1001/ios-architectures/tree/master/MVVM-RxSwift-rxflow)

### How to declare **Steps**

**Steps** are little pieces of states eventually expressing the intent to navigate, it is pretty convenient to declare them in a enum:
BeerStep

```swift
import RxFlow

enum BeerStep: Step {
    // Global
    case alert(String)
    
    // TabBar
    case TabBarIsRequired

    // Beer List
    case BeerListIsRequired
    case BeerDetailIsPicked (beer: Beer)

    // Search Beer
    case SearchBeerIsRequired

    // Random Beer
    case RandomBeerIsRequired
}
```



### How to declare a **Flow**

The following **Flow** is used as a Navigation stack. All you have to do is:

- Declare a root **Presentable** on which your navigation will be based.
- Implement the **navigate(to:)** function to transform a **Step** into a navigation actions.

SearchBeerFlow

```swift
import RxFlow
import UIKit

class SearchBeerFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? BeerStep else { return .none }

        switch step {
        case .SearchBeerIsRequired:
            return navigateToSearchBeerScreen()
        case .alert(let string):
            return alert(string: string)
        default:
            return .none
        }
    }

    private func navigateToSearchBeerScreen() -> FlowContributors {
        let vc = SearchBeerVC()
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func alert(string: String) -> FlowContributors {
        self.rootViewController.showErrorAlert(with: string)
        return .none
    }
}
```

SearchBeerViewModel

```swift
class SearchBeerViewModel: Stepper {
    let steps = PublishRelay<Step>()
    ...
}
```

### How to declare a **Stepper**

In theory a **Stepper**, as it is a protocol, can be anything (a UIViewController for instance) but a good practice is to isolate that behavior in a ViewModel or something similar.

AppStepper

```swift
class AppStepper: Stepper {
    let steps = PublishRelay<Step>()

    var initialStep: Step {
        return BeerStep.TabBarIsRequired
    }
}
```



## 🙂 Advantages

- Remove every navigation mechanism from UIViewControllers
- Promote reactive programming
- Express the navigation in a declarative way while addressing the majority of the navigation cases
- Facilitate the cutting of an application into logical blocks of navigation
- Dependency Injection made easy



