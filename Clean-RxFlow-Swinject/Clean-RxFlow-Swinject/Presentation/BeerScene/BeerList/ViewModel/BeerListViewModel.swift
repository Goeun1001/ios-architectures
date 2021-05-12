//
//  BeerListViewMoodel.swift
//  MVVM-RxSwift-snapKit
//
//  Created by GoEun Jeong on 2021/04/29.
//

import RxSwift
import RxCocoa
import RxFlow

class BeerListViewModel: Stepper {
    let steps = PublishRelay<Step>()
    
    private var page = 1
    private var disposeBag = DisposeBag()
    private let beerListUseCase: BeerListUseCase
    
    // MARK: - ViewModelType
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let refreshTrigger = PublishRelay<Void>()
        let nextPageTrigger = PublishRelay<Void>()
        let detailTrigger = PublishRelay<Beer>()
    }
    
    struct Output {
        let list = BehaviorRelay<[Beer]>(value: [])
        let isLoading = BehaviorRelay<Bool>(value: false)
        let isRefreshing = PublishRelay<Bool>()
        let errorRelay = PublishRelay<NetworkingError>()
    }
    
    let input = Input()
    let output = Output()
    
    init(beerListUseCase: BeerListUseCase) {
        self.beerListUseCase = beerListUseCase
        let activityIndicator = ActivityIndicator()
        let refreshIndicator = ActivityIndicator()
        
        input.viewDidLoad
            .asObservable()
            .flatMap {
                self.beerListUseCase.execute(page: self.page)
                    .trackActivity(activityIndicator)
                    .do(onError: { self.output.errorRelay.accept($0 as! NetworkingError) })
                    .catchErrorJustReturn([])
            }
            .bind(to: self.output.list)
            .disposed(by: disposeBag)
        
        input.refreshTrigger
            .asObservable()
            .map { self.page = 1 }
            .flatMap {
                self.beerListUseCase.execute(page: self.page)
                    .trackActivity(refreshIndicator)
                    .do(onError: { self.output.errorRelay.accept($0 as! NetworkingError) })
                    .catchErrorJustReturn([])
            }
            .bind(to: self.output.list)
            .disposed(by: disposeBag)
        
        
        input.nextPageTrigger
            .asObservable()
            .map { self.page += 1 }
            .flatMap {
                self.beerListUseCase.execute(page: self.page)
                    .trackActivity(activityIndicator)
                    .do(onError: { self.output.errorRelay.accept($0 as! NetworkingError) })
                    .catchErrorJustReturn([])
            }
            .map { self.output.list.value + $0 }
            .bind(to: self.output.list)
            .disposed(by: disposeBag)
        
        input.detailTrigger
            .asObservable()
            .subscribe(onNext: { beer in
                self.steps.accept(BeerStep.BeerDetailIsPicked(beer: beer))
            })
            .disposed(by: disposeBag)
        
        activityIndicator
            .asObservable()
            .bind(to: output.isLoading)
            .disposed(by: disposeBag)
        
        refreshIndicator
            .asObservable()
            .bind(to: output.isRefreshing)
            .disposed(by: disposeBag)
    }
}
