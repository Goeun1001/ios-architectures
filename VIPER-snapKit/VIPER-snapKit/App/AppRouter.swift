//
//  AppRouter.swift
//  VIPER-snapKit
//
//  Created by GoEun Jeong on 2021/05/12.
//

import UIKit

enum AppBaseRouterType {
    case tabbar
}

final class AppRouter {
    let navigationController: UINavigationController
    let networkingApi: NetworkingService
    private var childRouters: [AppBaseRouterType: NavigationRouterType]
    
    init(
        networkingApi: NetworkingService,
        navigationController: UINavigationController
    ) {
        self.networkingApi = networkingApi
        self.navigationController = navigationController
        self.childRouters = [:]
    }
    
    func start() {
        showTabbar()
    }
    
    func store(with router: NavigationRouterType, as type: AppBaseRouterType) {
        childRouters[type] = router
    }
}

extension AppRouter {
    private func showTabbar() {
        let tabbarRouter = TabbarRouter(navigationController: navigationController, networkingApi: networkingApi)
        tabbarRouter.start()
        store(with: tabbarRouter, as: .tabbar)
    }
}
