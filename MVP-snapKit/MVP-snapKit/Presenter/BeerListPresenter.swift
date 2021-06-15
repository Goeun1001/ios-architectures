//
//  BeerListPresenter.swift
//  MVP-snapKit
//
//  Created by GoEun Jeong on 2021/04/29.
//

import Foundation

protocol BeerListViewPresenter: AnyObject {
    init(view: BeerListView)
    func viewDidLoad()
    func refresh()
    func getNextPage()
    func getCurrentPage() -> Int
}

class BeerListPresenter: BeerListViewPresenter {
    private weak var view: BeerListView?
    private var page = 1
    
    let networkingApi: NetworkingService!
    
    // MARK: - Initialization
    
    required init(view: BeerListView) {
        self.view = view
        self.networkingApi = NetworkingAPI()
    }
    
    // MARK: - Life Cycle
    
    func viewDidLoad() {
        networkingApi.getBeerList(page: 1, completion: { [weak self] beers in
            self?.view?.onItemsReset(beers: beers)
        })
    }
    
    // MARK: - Public Methods
    
    func getCurrentPage() -> Int  {
        return self.page
    }
    
    func refresh() {
        self.page = 1
        networkingApi.getBeerList(page: 1, completion: { [weak self] beers in
            self?.view?.onItemsReset(beers: beers)
        })
    }
    
    func getNextPage() {
        self.page += 1
        networkingApi.getBeerList(page: self.page, completion: { [weak self] beers in
            self?.view?.onItemsRetrieval(beers: beers)
        })
    }
}
