# Coordinator (MVVM-C)

The **coordinator pattern** is a structural design **pattern** for organizing flow logic between view controllers. 



## 🙂 Advantages

- Storyboards are simplified, don’t have segues. Actually, they can be replaced with xib files.
- ViewControllers are much smaller.



## 🙁 Disadvantages

- RxSwift is tricky. If you are not careful enough, memory leaks are certain. Anyway, you will need to invest some time in debugging to make sure that everything is released as expected.
- RxSwift makes debugging harder.
- Implementation requires quite a lot of boilerplate. You need to create View, ViewModel, Coordinator for each part of your application and bind all together.





## [Example](https://github.com/Goeun1001/ios-architectures/tree/master/MVVM-C-RxSwift) - BeerListVC

```swift
tableView.rx.modelSelected(Beer.self)
     .subscribe(onNext: { [weak self] beer in
           self?.coordinator.goDetail(beer: beer)
      }).disposed(by: disposeBag)
```







### Reference

- [MVVM + Coordinators + RxSwift and sample iOS application with authentication](https://wojciechkulik.pl/ios/mvvm-coordinators-rxswift-and-sample-ios-application-with-authentication)

### Recommend

- https://github.com/leopug/CoordinatorTabbbarStudy

  It is an example of moving between multiple tabs of a tabbar, so it is good to feel the advantages of the coordinator.