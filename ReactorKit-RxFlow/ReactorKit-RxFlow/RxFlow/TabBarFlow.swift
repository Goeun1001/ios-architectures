//
//  TabBarFlow.swift
//  ReactorKit-RxSwift-snapKit
//
//  Created by GoEun Jeong on 2021/05/10.
//

import Foundation
import UIKit
import RxFlow

class TabBarFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    let rootViewController = UITabBarController()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? BeerStep else { return .none }

        switch step {
        case .TabBarIsRequired:
            return navigateToTabBar()
        default:
            return .none
        }
    }

    private func navigateToTabBar() -> FlowContributors {

        let beerListFlow = BeerListFlow()
        let searchBeerFlow = SearchBeerFlow()
        let randomBeerFlow = RandomBeerFlow()

        Flows.use(beerListFlow, searchBeerFlow, randomBeerFlow, when: .ready) { [unowned self] (root1: UINavigationController, root2: UINavigationController, root3: UINavigationController) in
            root1.tabBarItem = UITabBarItem(title: "Beer List", image: UIImage(systemName: "1.circle"), tag: 0)
            root2.tabBarItem = UITabBarItem(title: "Search ID", image: UIImage(systemName: "2.circle"), tag: 1)
            root3.tabBarItem = UITabBarItem(title: "Random", image: UIImage(systemName: "3.circle"), tag: 2)

            self.rootViewController.setViewControllers([root1, root2, root3], animated: false)
        }

        return .multiple(flowContributors: [.contribute(withNextPresentable: beerListFlow,
                                                        withNextStepper: OneStepper(withSingleStep: BeerStep.BeerListIsRequired)),
                                            .contribute(withNextPresentable: searchBeerFlow,
                                                        withNextStepper: OneStepper(withSingleStep: BeerStep.SearchBeerIsRequired)),
                                            .contribute(withNextPresentable: randomBeerFlow,
                                                        withNextStepper: OneStepper(withSingleStep: BeerStep.RandomBeerIsRequired))])
    }
}
