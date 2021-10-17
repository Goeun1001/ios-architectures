//
//  RandomBeerPresenter.swift
//  VIPER-snapKit
//
//  Created by GoEun Jeong on 2021/05/12.
//  
//

import Foundation
import RxCocoa
import RxSwift

class RandomBeerPresenter: RandomBeerPresenterProtocol {
    
    // MARK: Properties
    let interactor: RandomBeerInteractorProtocol
    let router: RandomBeerRouterProtocol
    private let disposeBag = DisposeBag()
    
    
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
    
    init(interactor: RandomBeerInteractorProtocol,
         router: RandomBeerRouterProtocol) {
        self.interactor = interactor
        self.router = router
        let activityIndicator = ActivityIndicator()
        
        input.buttonTrigger
            .asObservable()
            .flatMapLatest {
                interactor.fetchRandomBeerfromAPI()
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
