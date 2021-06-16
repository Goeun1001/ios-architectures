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
    @Inject private var searchBeerUseCase: SearchBeerUseCase
    
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
    
    
    init() {
        let activityIndicator = ActivityIndicator()
        
        input.searchTrigger
            .asObservable()
            .flatMapLatest { id in
                self.searchBeerUseCase.execute(id: Int(id) ?? 0)
                    .trackActivity(activityIndicator)
                    .do(onError: { [weak self] error in
                        let error = error as! NetworkingError
                        self?.steps.accept(BeerStep.alert(error.message))
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
