//
//  RandomBeerContract.swift
//  VIPER-snapKit
//
//  Created by GoEun Jeong on 2021/05/12.
//  
//

import Foundation
import RxSwift

protocol RandomBeerViewProtocol {
    var presenter: RandomBeerPresenter { get }
}

protocol RandomBeerPresenterProtocol {
    var interactor: RandomBeerInteractorProtocol { get }
    var router: RandomBeerRouterProtocol { get }
}

protocol RandomBeerInteractorProtocol {
    var networkingApi: NetworkingService { get }
    
    func fetchRandomBeerfromAPI() -> Single<[Beer]>
}

protocol RandomBeerRouterProtocol {
    func showAlert(string: String)
}
