//
//  SearchBeerContract.swift
//  VIPER-snapKit
//
//  Created by GoEun Jeong on 2021/05/12.
//  
//

import Foundation
import RxSwift

protocol SearchBeerViewProtocol {
    var presenter: SearchBeerPresenter { get }
}

protocol SearchBeerPresenterProtocol {
    var interactor: SearchBeerInteractorProtocol { get }
    var router: SearchBeerRouterProtocol { get }
}

protocol SearchBeerInteractorProtocol {
    var networkingApi: NetworkingService { get }

    func fetchSearchBeerfromAPI(id: Int) -> Single<[Beer]>
}

protocol SearchBeerRouterProtocol {
    func showAlert(string: String)
}
