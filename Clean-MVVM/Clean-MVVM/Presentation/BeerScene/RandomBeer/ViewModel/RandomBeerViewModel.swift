//
//  RandomBeerViewModel.swift
//  MVVM-RxSwift-snapKit
//
//  Created by GoEun Jeong on 2021/04/29.
//

import RxSwift
import RxCocoa

class RandomBeerViewModel {
    private let disposeBag = DisposeBag()
    private let randomBeerUseCase: RandomBeerUseCase
    
    // MARK: - ViewModelType
    
    struct Input {
        let buttonTrigger = PublishRelay<Void>()
    }
    
    struct Output {
        let beer = BehaviorRelay<[Beer]>(value: [])
        let isLoading = BehaviorRelay<Bool>(value: false)
        let errorRelay = PublishRelay<NetworkingError>()
    }
    
    let input = Input()
    let output = Output()
    
    init(randomBeerUseCase: RandomBeerUseCase) {
        self.randomBeerUseCase = randomBeerUseCase
        let activityIndicator = ActivityIndicator()
        
        input.buttonTrigger
            .asObservable()
            .flatMapLatest {
                randomBeerUseCase.execute()
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
