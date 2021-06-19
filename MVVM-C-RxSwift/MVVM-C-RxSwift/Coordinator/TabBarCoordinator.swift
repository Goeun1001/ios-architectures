//
//  TabBarCoordinatorr.swift
//  MVVM-C-RxSwift-snapKit
//
//  Created by GoEun Jeong on 2021/05/04.
//

import UIKit

enum TabbarFlow {
    case beerList
    case searchBeer
    case randomBeer
}

class TabBarCoordinator: BaseCoordinator {
    private let beerListCoordinator = BeerListCoordinator(navigationController: UINavigationController())
    private let searchBeerCoordinator = SearchBeerCoordinator(navigationController: UINavigationController())
    private let randomBeerCoordinator = RandomBeerCoordinator(navigationController: UINavigationController())
    private let tabbarController = UITabBarController()
    
    override func start() {
        start(coordinator: beerListCoordinator)
        start(coordinator: searchBeerCoordinator)
        start(coordinator: randomBeerCoordinator)
        
        beerListCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Beer List", image: UIImage(systemName: "1.circle"), tag: 0)
        searchBeerCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Search ID", image: UIImage(systemName: "2.circle"), tag: 1)
        randomBeerCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Random", image: UIImage(systemName: "3.circle"), tag: 2)
        
        self.tabbarController.viewControllers = [beerListCoordinator.navigationController, searchBeerCoordinator.navigationController, randomBeerCoordinator.navigationController]
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabbarController, animated: false)
    }
    
    func moveTo(flow: TabbarFlow) {
        switch flow {
        case .beerList:
            tabbarController.selectedIndex = 0
        case .searchBeer:
            tabbarController.selectedIndex = 1
        case .randomBeer:
            tabbarController.selectedIndex = 2
        }
    }
    
}

