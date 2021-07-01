# VIPER

![RIBs Architecture 도입 시리즈 1편: RIBs란? | by 강동희 | 매스프레소 팀블로그](https://miro.medium.com/max/2780/1*9gyvu_gEOqMP2cqVx6UUTg.png)

- View
  - UIViewController
  - View Life Cycle: ex) The viewDidLoad function calls and notifies the presenter
  - View Event: ex) Notify the presenter when signUpButton is clicked
  - View Control: ex) Provide Presenter how to change the titleLabel's text
- Presenter
  - A bridge between View and Interactor
  - Business logic for View
    - Treatment of life cycle
    - Handling of View Event
    - View update
  - UIKit Independent
- Interactor
  - Business logic for Data(Entity)
  - API request or DB CRUD
- Entity
  - Data model of network, DB, etc.
  - Realm Object, NSUserDefuatls, Json Data, etc.
  - Used in Interactor
- Router(Wireframe)
  - Switch between Views 
  - Responsible for DI (Dependency Injection) of VIPER components
- VIPER with Swift - Protocol
  - Define View, Presenter, Interactor, and Router as protocols



## 🙂 Advantages

- Clearly separate code into functional units on one screen
- A structure that becomes testable for all components
- The division of labor is much easier



## 🙁 Disadvantages

- More code to write, even for simple screens and functions



## Example - [Viper + Rx](https://github.com/Goeun1001/ios-architectures/tree/master/VIPER-snapKit)

Contract(Define Protocol)

```swift
import Foundation
import RxSwift

protocol SearchBeerViewProtocol {
    var presenter: SearchBeerPresenter { get }
}


protocol SearchBeerPresenterProtocol {
    var interactor: SearchBeerInteractorProtocol { get }
    var router: SearchBeerRouterProtocol { get }
}


protocol SearchBeerInteractorProtocol {
    var networkingApi: NetworkingService { get }

    func fetchSearchBeerfromAPI(id: Int) -> Single<[Beer]>
}


protocol SearchBeerRouterProtocol {
    func showAlert(string: String)
}
```

View

```swift
import UIKit
import RxSwift
import RxCocoa

class SearchBeerViewController: UIViewController, SearchBeerViewProtocol {
    // MARK: - Properties
    let presenter: SearchBeerPresenter
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(presenter: SearchBeerPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        searchController.searchBar.rx.text
            .orEmpty
            .filter { $0 != "" }
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: presenter.input.searchTrigger)
            .disposed(by: disposeBag)
        
        presenter.output.beer
            .subscribe(onNext: { [weak self] beer in
                self?.beerView.setupView(model: beer.first ?? Beer(id: nil, name: "Please Search Beer By ID", description: "", imageURL: ""))
            })
            .disposed(by: disposeBag)
        
        presenter.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
```

Presenter

```swift

import Foundation
import RxCocoa
import RxSwift

class SearchBeerPresenter: SearchBeerPresenterProtocol {

    // MARK: Properties
    let interactor: SearchBeerInteractorProtocol
    let router: SearchBeerRouterProtocol
    private var disposeBag = DisposeBag()
    
    // MARK: - ViewModelType
    
    struct Input {
        let searchTrigger = PublishRelay<String>()
    }
    
    struct Output {
        let beer = BehaviorRelay<[Beer]>(value: [])
        let isLoading = BehaviorRelay<Bool>(value: false)
    }
    
    let input = Input()
    let output = Output()
    
    init(interactor: SearchBeerInteractorProtocol,
         router: SearchBeerRouterProtocol) {
        self.interactor = interactor
        self.router = router
        let activityIndicator = ActivityIndicator()
        
        input.searchTrigger
            .asObservable()
            .flatMapLatest { id in
                interactor.fetchSearchBeerfromAPI(id: Int(id) ?? 0)
                    .trackActivity(activityIndicator)
                    .do(onError: { self.router.showAlert(string: $0.localizedDescription) })
                    .catchErrorJustReturn([])
            }
            .bind(to: output.beer)
            .disposed(by: disposeBag)
        
        activityIndicator
            .asObservable()
            .bind(to: output.isLoading)
            .disposed(by: disposeBag)
    }
}
```

Interactor

```swift
import Foundation
import RxSwift

class SearchBeerInteractor: SearchBeerInteractorProtocol {
    let networkingApi: NetworkingService
    
    init(networkingApi: NetworkingService) {
        self.networkingApi = networkingApi
    }
    
    func fetchSearchBeerfromAPI(id: Int) -> Single<[Beer]> {
        networkingApi.request(.searchID(id: id)) // request API
    }
}
```

Router

```swift
import Foundation
import UIKit

class SearchBeerRouter: SearchBeerRouterProtocol, NavigationRouterType {
    let navigationController: UINavigationController
    let networkingApi: NetworkingService
    
    init(navigationController: UINavigationController,
         networkingApi: NetworkingService) {
        self.navigationController = navigationController
        self.networkingApi = networkingApi
    }
    
    func start() {
        showSearchBeer()
    }
    
    func showSearchBeer() { // DI
        let interactor = SearchBeerInteractor(networkingApi: networkingApi)
        let presenter = SearchBeerPresenter(interactor: interactor, router: self)
        
        let viewController = SearchBeerViewController(presenter: presenter)
        navigationController.show(viewController, sender: nil)
    }
    
    func showAlert(string: String) {
        navigationController.showErrorAlert(with: string)
    }
}
```

This Example use Xcode File Template - [Viper-Rx-Template](https://github.com/Goeun1001/VIPER-Rx-Template)

It makes it easy to create a VIPER file for a view.