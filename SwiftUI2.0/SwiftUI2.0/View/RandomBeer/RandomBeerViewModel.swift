//
//  RandomBeerViewModel.swift
//  SwiftUI-MV
//
//  Created by GoEun Jeong on 2021/05/13.
//

import Combine
import Foundation

class RandomBeerViewModel: ObservableObject {
    @Published var beer = Beer(id: nil, name: "Loading...", description: nil, imageURL: nil)
    @Published var isLoading = false
    @Published var isErrorAlert = false
    @Published var errorMessage = ""

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
        case getRandom
    }

    private let getRandomSubject = PassthroughSubject<Void, Never>()

    private let beerSubject = PassthroughSubject<[Beer], Never>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()

    func apply(_ input: Input) {
        switch input {
        case .getRandom:
            getRandomSubject.send(())
        }
    }

    func bindInputs() {
        getRandomSubject
            .flatMap { [networkingApi] _ in
                networkingApi.request(.random)
                    .catch { [weak self] error -> Empty<[Beer], Never> in
                        self?.errorSubject.send(error)
                        return .init()
                    }
            }.share()
            .subscribe(beerSubject)
            .store(in: &bag)

        getRandomSubject
            .map { _ in true }
            .share()
            .subscribe(isLoadingSubject)
            .store(in: &bag)
    }

    func bindOutputs() {
        isLoadingSubject
            .assign(to: \.isLoading, on: self)
            .store(in: &bag)

        beerSubject
            .map { _ in false }
            .assign(to: \.isLoading, on: self)
            .store(in: &bag)

        beerSubject
            .map { $0.first! }
            .assign(to: \.beer, on: self)
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
}
