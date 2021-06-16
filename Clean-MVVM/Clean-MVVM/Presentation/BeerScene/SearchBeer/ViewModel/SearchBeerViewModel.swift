//
//  SearchBeerViewModel.swift
//  MVVM-RxSwift-snapKit
//
//  Created by GoEun Jeong on 2021/04/29.
//

import RxSwift
import RxCocoa

class SearchBeerViewModel {
    private var disposeBag = DisposeBag()
    private let searchBeerUseCase: SearchBeerUseCase
    
    // MARK: - ViewModelType
    
    struct Input {
        let searchTrigger = PublishRelay<String>()
    }
    
    struct Output {
        let beer = BehaviorRelay<[Beer]>(value: [])
        let isLoading = BehaviorRelay<Bool>(value: false)
        let errorRelay = PublishRelay<NetworkingError>()
    }
    
    let input = Input()
    let output = Output()
    
    
    init(searchBeerUseCase: SearchBeerUseCase) {
        self.searchBeerUseCase = searchBeerUseCase
        let activityIndicator = ActivityIndicator()
        
        input.searchTrigger
            .asObservable()
            .flatMapLatest { id in
                searchBeerUseCase.execute(id: Int(id) ?? 0)
                    .trackActivity(activityIndicator)
                    .do(onError: { self.output.errorRelay.accept($0 as! NetworkingError) })
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
