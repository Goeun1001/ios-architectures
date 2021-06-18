//
//  BeerListViewModel.swift
//  SwiftUI-MV
//
//  Created by GoEun Jeong on 2021/05/13.
//

import UIKit

class BeerListViewModel: ObservableObject {
    @Published var beers: [Beer] = .init()
    @Published var page = 1
    @Published var isLoading = false
    @Published var isErrorAlert = false
    @Published var errorMessage = ""
    
    let networkingApi: NetworkingService
    var refreshControl : UIRefreshControl?
    
    init(networkingApi: NetworkingService = NetworkingAPI()) {
        self.networkingApi = networkingApi
    }
    
    func checkNextPage(id: Int) {
        if id == page * 25 {
            self.page += 1
            self.appendBeerList()
        }
    }
    
    func onAppear() {
        self.isLoading = true
        networkingApi.request(.getBeerList(page: page)) { result in
            switch result {
            case let .success(beers):
                self.beers = beers
            case let .failure(error):
                self.errorMessage = error.localizedDescription
                self.isErrorAlert = true
            }
        }
        self.isLoading = false
    }
    
    private func appendBeerList() {
        self.isLoading = true
        networkingApi.request(.getBeerList(page: page)) { result in
            switch result {
            case let .success(beers):
                self.beers += beers
            case let .failure(error):
                self.errorMessage = error.localizedDescription
                self.isErrorAlert = true
            }
        }
        self.isLoading = false
    }
    
    @objc func refresh() {
        self.refreshControl?.beginRefreshing()
        self.page = 1
        self.onAppear()
        self.refreshControl?.endRefreshing()
    }
}
