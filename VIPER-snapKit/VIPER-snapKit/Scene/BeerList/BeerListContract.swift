//
//  BeerListContract.swift
//  VIPER-snapKit
//
//  Created by GoEun Jeong on 2021/05/12.
//  
//

import Foundation
import UIKit
import RxSwift

protocol BeerListViewProtocol {
    var presenter: BeerListPresenter { get }
}

protocol BeerListPresenterProtocol {
    var interactor: BeerListInteractorProtocol { get }
    var router: BeerListRouterProtocol { get }
}

protocol BeerListInteractorProtocol {
    var networkingApi: NetworkingService { get }

    func fetchBeerListfromAPI(page: Int) -> Single<[Beer]>
}

protocol BeerListRouterProtocol {
    func showAlert(string: String)
    func showBeerDetail(beer: Beer)
}
