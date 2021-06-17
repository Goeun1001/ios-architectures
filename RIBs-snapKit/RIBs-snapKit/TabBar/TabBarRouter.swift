//
//  TabBarRouter.swift
//  RIBs-snapKit
//
//  Created by GoEun Jeong on 2021/05/16.
//

import RIBs
import UIKit

protocol TabBarInteractable: Interactable, BeerListListener, RandomBeerListener, SearchBeerListener {
    var router: TabBarRouting? { get set }
    var listener: TabBarListener? { get set }
}

protocol TabBarViewControllable: ViewControllable {
    func present(viewControllers: [UIViewController])
}

final class TabBarRouter: LaunchRouter<TabBarInteractable, TabBarViewControllable>, TabBarRouting {
    
    private let beerListBuilder: BeerListBuildable
    private var beerList: ViewableRouting?
    private let randomBeerBuilder: RandomBeerBuildable
    private var randomBeer: ViewableRouting?
    private let searchBeerBuilder: SearchBeerBuildable
    private var searchBeer: ViewableRouting?
    
    private var listNavigationVC: UINavigationController?

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: TabBarInteractable,
         viewController: TabBarViewControllable,
         beerListBuilder: BeerListBuildable,
         randomBeerBuilder: RandomBeerBuildable,
         searchBeerBuilder: SearchBeerBuildable) {
        self.beerListBuilder = beerListBuilder
        self.randomBeerBuilder = randomBeerBuilder
        self.searchBeerBuilder = searchBeerBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()

        tabBar()
    }
    
    func tabBar() {
        setBeerList()
        setSearchBeer()
        setRandomBeer()
        
        self.listNavigationVC = UINavigationController(rootViewController: beerList!.viewControllable.uiviewController)
        let searchNavigationVC = UINavigationController(rootViewController: searchBeer!.viewControllable.uiviewController)
        let randomNavigationVC = UINavigationController(rootViewController: randomBeer!.viewControllable.uiviewController)
        viewController.present(viewControllers: [listNavigationVC!, searchNavigationVC, randomNavigationVC])
    }
    
    private func setBeerList() {
        let beerList = beerListBuilder.build(withListener: interactor)
        self.beerList = beerList
        attachChild(beerList)
        beerList.viewControllable.uiviewController.tabBarItem = UITabBarItem(title: "Beer List", image: UIImage(systemName: "1.circle"), tag: 0)
    }
    
    private func setSearchBeer() {
        let searchBeer = searchBeerBuilder.build(withListener: interactor)
        self.searchBeer = searchBeer
        attachChild(searchBeer)
        searchBeer.viewControllable.uiviewController.tabBarItem = UITabBarItem(title: "Search ID", image: UIImage(systemName: "2.circle"), tag: 1)
    }
    
    private func setRandomBeer() {
        let randomBeer = randomBeerBuilder.build(withListener: interactor)
        self.randomBeer = randomBeer
        attachChild(randomBeer)
        randomBeer.viewControllable.uiviewController.tabBarItem = UITabBarItem(title: "Random", image: UIImage(systemName: "3.circle"), tag: 2)
    }
    
    func goDetailBeer(beer: Beer) {
//        let detailBeerVC = DetailBeerViewController(beer: beer)
//        listNavigationVC!.pushViewController(detailBeerVC, animated: true)
    }
    
}
