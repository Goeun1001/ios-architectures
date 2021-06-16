//
//  RandomBeerViewModel.swift
//  MVVM-RxSwift-snapKit
//
//  Created by GoEun Jeong on 2021/04/29.
//

import RxSwift
import RxCocoa
import RxFlow

class RandomBeerViewModel: Stepper {
    let steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    @Inject private var randomBeerUseCase: RandomBeerUseCase
    
    // MARK: - ViewModelType
    
    struct Input {
        let buttonTrigger = PublishRelay<Void>()
    }
    
    struct Output {
        let beer = BehaviorRelay<[Beer]>(value: [])
        let isLoading = BehaviorRelay<Bool>(value: false)
    }
    
    let input = Input()
    let output = Output()
    
    init() {
        let activityIndicator = ActivityIndicator()
        
        input.buttonTrigger
            .asObservable()
            .flatMapLatest {
                self.randomBeerUseCase.execute()
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
