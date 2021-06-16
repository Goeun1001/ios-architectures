//
//  Container+RegisterDependencies.swift
//  MVVM-C-RxSwift-swinject
//
//  Created by GoEun Jeong on 2021/05/06.
//

import Swinject
import SwinjectAutoregistration

extension Container {
    func registerDependencies() {
        registerCoordinators()
        registerViewModels()
    }
    
    func registerCoordinators() {
        autoregister(AppCoordinator.self, initializer: AppCoordinator.init)
        autoregister(TabBarCoordinator.self, initializer: TabBarCoordinator.init)
        autoregister(BeerListCoordinator.self, initializer: BeerListCoordinator.init)
        autoregister(SearchBeerCoordinator.self, initializer: SearchBeerCoordinator.init)
        autoregister(RandomBeerCoordinator.self, initializer: RandomBeerCoordinator.init)
    }
    
    func registerViewModels() {
        autoregister(NetworkingService.self, initializer: NetworkingAPI.init as () -> NetworkingAPI)
        autoregister(BeerListViewModel.self, initializer: BeerListViewModel.init)
        autoregister(RandomBeerViewModel.self, initializer: RandomBeerViewModel.init)
        autoregister(SearchBeerViewModel.self, initializer: SearchBeerViewModel.init)
    }
}
