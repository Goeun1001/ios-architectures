//
//  BeerListUseCase.swift
//  Clean-MVVM
//
//  Created by GoEun Jeong on 2021/05/10.
//

import Foundation
import RxSwift

protocol BeerListUseCase {
    func execute(page: Int) -> Single<[Beer]>
}

final class DefaultBeerListUseCase: BeerListUseCase {
    @Inject private var beerListRepository: BeerListRepository
    
    func execute(page: Int) -> Single<[Beer]> {
        return beerListRepository.getBeerList(page: page)
    }
}

