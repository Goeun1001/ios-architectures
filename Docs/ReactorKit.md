# ReactorKit

## [Official](https://github.com/ReactorKit/ReactorKit)

![flow](https://cloud.githubusercontent.com/assets/931655/25073432/a91c1688-2321-11e7-8f04-bf91031a09dd.png)

## Basic Concept

ReactorKit is a combination of [Flux](https://facebook.github.io/flux/) and [Reactive Programming](https://en.wikipedia.org/wiki/Reactive_programming). The user actions and the view states are delivered to each layer via observable streams. These streams are unidirectional: the view can only emit actions and the reactor can only emit states.

### Design Goal

- **Testability**: The first purpose of ReactorKit is to separate the business logic from a view. This can make the code testable. A reactor doesn't have any dependency to a view. Just test reactors and test view bindings. See [Testing](https://github.com/ReactorKit/ReactorKit#testing) section for details.
- **Start Small**: ReactorKit doesn't require the whole application to follow a single architecture. ReactorKit can be adopted partially, for one or more specific views. You don't need to rewrite everything to use ReactorKit on your existing project.
- **Less Typing**: ReactorKit focuses on avoiding complicated code for a simple thing. ReactorKit requires less code compared to other architectures. Start simple and scale up.



### View

A *View* displays data.

To define a view, just have an existing class conform a protocol named `View`. Then your class will have a property named `reactor` automatically. This property is typically set outside of the view.

```swift
class BeerListVC: UIViewController, View {
    typealias Reactor = BeerListReactor
  
	  init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
}
```

When the `reactor` property has changed, `bind(reactor:)` gets called. Implement this method to define the bindings of an action stream and a state stream.

```swift
func bind(reactor: Reactor) {
        self.bindAction(reactor: reactor)
        self.bindState(reactor: reactor)
    }

private func bindAction(reactor: Reactor) {
    // action (View -> Reactor)
        self.rx.viewWillAppear.map{ _ in Void() }
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
}

private func bindState(reactor: Reactor) {
  // state (Reactor -> View)
         reactor.state.map { $0.isLoading }
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
```

(Storyboard Support)

### Reactor

A *Reactor* is an UI-independent layer which manages the state of a view. The foremost role of a reactor is to separate control flow from a view. Every view has its corresponding reactor and delegates all logic to its reactor. A reactor has no dependency to a view, so it can be easily tested.

Conform to the `Reactor` protocol to define a reactor. This protocol requires three types to be defined: `Action`, `Mutation` and `State`. It also requires a property named `initialState`.

```swift
final class BeerListReactor: Reactor {
  // represent user actions
  enum Action {
        case viewWillAppear
        case refresh
        case nextPage
        case detailBeer(Beer)
    }
    
    enum Mutation {
      // represent state changes
        case setBeers([Beer])
        case appendBeers([Beer])
        case setRefreshing(Bool)
        case setError(String)
        case setLoading(Bool)
        case detailBeer(Beer)
    }
    
    struct State {
      // represents the current view state
        var list: [Beer] = .init()
        var isRefreshing: Bool = false
        var isLoading: Bool = false
    }
    
    let initialState: State = .init()
}
```

An `Action` represents a user interaction and `State` represents a view state. `Mutation` is a bridge between `Action` and `State`. A reactor converts the action stream to the state stream in two steps: `mutate()` and `reduce()`.

![flow-reactor](https://cloud.githubusercontent.com/assets/931655/25098066/2de21a28-23e2-11e7-8a41-d33d199dd951.png)

#### `mutate()`

`mutate()` receives an `Action` and generates an `Observable<Mutation>`.

```swift
func mutate(action: Action) -> Observable<Mutation>
```

Every side effect, such as an async operation or API call, is performed in this method.

```swift
func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear: // receive an action
            let startLoading: Observable<Mutation> = .just(.setLoading(true))
            let endLoading: Observable<Mutation> = .just(.setLoading(false))
            let beerList: Observable<Mutation> =
                networkingApi.request(.getBeerList(page: self.page)) // create an API stream
                .asObservable()
                .map { return .setBeers($0) } // convert to Mutation stream
                .catchError {
                    return .just(.setError($0.localizedDescription)) }
            return .concat([startLoading, beerList, endLoading])
        }
```

#### `reduce()`

`reduce()` generates a new `State` from a previous `State` and a `Mutation`.

```swift
func reduce(state: State, mutation: Mutation) -> State
```

This method is a pure function. It should just return a new `State` synchronously. Don't perform any side effects in this function.

```swift
func reduce(state: State, mutation: Mutation) -> State {
        var state = state // create a copy of the old state
        switch mutation {
        case .setBeers(let beers):
            state.list = beers // manipulate the state, creating a new state
        
        case .appendBeers(let beers):
            state.list += beers
            
        case .setRefreshing(let isRefreshing):
            state.isRefreshing = isRefreshing
            
        case .setLoading(let isLoading):
            state.isLoading = isLoading
            
        case .setError(let error):
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)  {
                self.steps.accept(BeerStep.alert(error))
            }
        case .detailBeer(let beer):
            self.steps.accept(BeerStep.BeerDetailIsPicked(beer: beer))
        }
  
   			 return state
}
```



## 🙂 Advantages

- The usage forced by the framework is quite clear and the readability is good. If you are using reactive programming and MVVM in the traditional way, you can adopt it the traditional way.

  Even if an existing app already exists, it was also advantageous to introduce ReactorKit from a small unit and refactor it easily.

- Also, it was good that the mutate() function converts the Action stream into a Mutation stream, which handles asynchronous logic and side effects at this point, enabling consistent asynchronous code management.