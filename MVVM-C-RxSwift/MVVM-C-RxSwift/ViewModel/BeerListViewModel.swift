//
//  BeerListViewMoodel.swift
//  MVVM-RxSwift-snapKit
//
//  Created by GoEun Jeong on 2021/04/29.
//

import RxSwift
import RxCocoa

class BeerListViewModel {
    private var page = 1
    private let disposeBag = DisposeBag()
    private let networkingApi: NetworkingService!
    
    // MARK: - ViewModelType
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let refreshTrigger = PublishRelay<Void>()
        let nextPageTrigger = PublishRelay<Void>()
    }
    
    struct Output {
        let list = BehaviorRelay<[Beer]>(value: [])
        let isLoading = BehaviorRelay<Bool>(value: false)
        let isRefreshing = PublishRelay<Bool>()
        let errorRelay = PublishRelay<Error>()
    }
    
    let input = Input()
    let output = Output()
    
    init(networkingApi: NetworkingService = NetworkingAPI()) {
        self.networkingApi = networkingApi
        let activityIndicator = ActivityIndicator()
        let refreshIndicator = ActivityIndicator()
        
        input.viewDidLoad
            .asObservable()
            .flatMapLatest {
                networkingApi.request(.getBeerList(page: self.page))
                    .trackActivity(activityIndicator)
                    .do(onError: { [weak self] error in
                        self?.output.errorRelay.accept(error)
                    })
            }
            .bind(to: output.list)
            .disposed(by: disposeBag)
        
        input.refreshTrigger
            .asObservable()
            .map { [weak self] _ in
                self?.page = 1
            }
            .flatMapLatest {
                networkingApi.request(.getBeerList(page: self.page))
                    .trackActivity(refreshIndicator)
                    .do(onError: { [weak self] error in
                        self?.output.errorRelay.accept(error)
                    })
            }
            .bind(to: output.list)
            .disposed(by: disposeBag)
        
        
        input.nextPageTrigger
            .asObservable()
            .map { [weak self] _ in
                self?.page += 1
            }
            .flatMapLatest {
                networkingApi.request(.getBeerList(page: self.page))
                    .trackActivity(activityIndicator)
                    .do(onError: { [weak self] error in
                        self?.output.errorRelay.accept(error)
                    })
            }
            .map { self.output.list.value + $0 }
            .bind(to: output.list)
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
