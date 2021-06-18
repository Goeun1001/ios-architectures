//
//  BeerListViewModel.swift
//  SwiftUI-MV
//
//  Created by GoEun Jeong on 2021/05/13.
//

import Combine
import UIKit

class BeerListViewModel: ObservableObject {
    @Published var beers: [Beer] = .init()
    @Published var page = 1
    @Published var isLoading = false
    @Published var isErrorAlert = false
    @Published var errorMessage = ""
    
    var refreshControl : UIRefreshControl?

    private var bag = Set<AnyCancellable>()
    let networkingApi: NetworkingService

    init(networkingApi: NetworkingService = NetworkingAPI()) {
        self.networkingApi = networkingApi
        bindInputs()
        bindOutputs()
    }

    deinit {
        bag.removeAll()
    }

    // MARK: Input

    enum Input {
        case getBeerList
    }

    private let getBeerListSubject = PassthroughSubject<Void, Never>()

    private let beerListSubject = PassthroughSubject<[Beer], Never>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()

    func apply(_ input: Input) {
        switch input {
        case .getBeerList:
            getBeerListSubject.send(())
        }
    }

    func bindInputs() {
        getBeerListSubject
            .flatMap { [networkingApi] _ in
                networkingApi.request(.getBeerList(page: self.page))
                    .catch { [weak self] error -> Empty<[Beer], Never> in
                        self?.errorSubject.send(error)
                        return .init()
                    }
            }.share()
            .subscribe(beerListSubject)
            .store(in: &bag)

        getBeerListSubject
            .map { _ in true }
            .share()
            .subscribe(isLoadingSubject)
            .store(in: &bag)
    }

    func bindOutputs() {
        isLoadingSubject
            .assign(to: \.isLoading, on: self)
            .store(in: &bag)

        beerListSubject
            .map { _ in false }
            .assign(to: \.isLoading, on: self)
            .store(in: &bag)

        beerListSubject
            .assign(to: \.beers, on: self)
            .store(in: &bag)

        errorSubject
            .map { _ in false }
            .assign(to: \.isLoading, on: self)
            .store(in: &bag)

        errorSubject
            .map { _ in true }
            .assign(to: \.isErrorAlert, on: self)
            .store(in: &bag)

        errorSubject
            .map { $0.localizedDescription }
            .assign(to: \.errorMessage, on: self)
            .store(in: &bag)
    }
    
    func refresh() {
        self.refreshControl?.beginRefreshing()
        self.page = 1
        getBeerListSubject.send(())
        self.refreshControl?.endRefreshing()
    }

    func checkNextPage(id: Int) {
        if id == page * 25 {
            page += 1
            apply(.getBeerList)
        }
    }
}
