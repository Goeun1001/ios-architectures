//
//  RandomBeerPresenter.swift
//  MVP-snapKit
//
//  Created by GoEun Jeong on 2021/04/29.
//

import Foundation

protocol RandomBeerViewPresenter: AnyObject {
    init(view: RandomView)
    func getRandom()
}

class RandomBeerPresenter: RandomBeerViewPresenter {
    private weak var view: RandomView?
    
    let networkingApi: NetworkingService!
    
    // MARK: - Initialization
    
    required init(view: RandomView) {
        self.view = view
        self.networkingApi = NetworkingAPI()
    }
    
    func getRandom() {
        networkingApi.getRandomBeer(completion: { [weak self] beers in
            self?.view?.onItemsRetrieval(beers: beers)
        })
    }
    
}
