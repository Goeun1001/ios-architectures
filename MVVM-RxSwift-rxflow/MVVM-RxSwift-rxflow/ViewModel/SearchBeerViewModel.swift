//
//  SearchBeerViewModel.swift
//  MVVM-RxSwift-snapKit
//
//  Created by GoEun Jeong on 2021/04/29.
//

import RxSwift
import RxCocoa
import RxFlow

class SearchBeerViewModel: Stepper {
    let steps = PublishRelay<Step>()
    
    private var disposeBag = DisposeBag()
    private let networkingApi: NetworkingService!
    
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
    
    
    init(networkingApi: NetworkingService = NetworkingAPI()) {
        self.networkingApi = networkingApi
        let activityIndicator = ActivityIndicator()
        
        input.searchTrigger
            .asObservable()
            .flatMapLatest { id in
                networkingApi.request(.searchID(id: Int(id) ?? 0))
                    .trackActivity(activityIndicator)
                    .do(onError: { [weak self] error in
                        self?.steps.accept(BeerStep.alert(error.localizedDescription))
                    })
            }
            .bind(to: output.beer)
            .disposed(by: disposeBag)
        
        activityIndicator
            .asObservable()
            .bind(to: output.isLoading)
            .disposed(by: disposeBag)
    }
}
