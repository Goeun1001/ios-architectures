//
//  SearchBeerPrersenter.swift
//  MVP-snapKit
//
//  Created by GoEun Jeong on 2021/04/29.
//

import Foundation

protocol SearchBeerViewPresenter: AnyObject {
    init(view: SearchView)
    func search(id: Int)
}

class SearchBeerPresenter: SearchBeerViewPresenter {
    private weak var view: SearchView?
    
    let networkingApi: NetworkingService!
    
    // MARK: - Initialization
    
    required init(view: SearchView) {
        self.view = view
        self.networkingApi = NetworkingAPI()
    }
    
    func search(id: Int) {
        networkingApi.searchBeer(id: id, completion: { [weak self] beers in
            self?.view?.onItemsRetrieval(beers: beers)
        })
    }
    
}
