//
//  AppFlow.swift
//  ReactorKit-RxSwift-snapKit
//
//  Created by GoEun Jeong on 2021/05/10.
//

import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift

class AppFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? BeerStep else { return .none }

        switch step {
        case .TabBarIsRequired:
            return navigationToDashboardScreen()
        default:
            return .none
        }
    }

    private func navigationToDashboardScreen() -> FlowContributors {
        let dashboardFlow = TabBarFlow()

        Flows.use(dashboardFlow, when: .ready) { [unowned self] root in
            self.rootViewController.pushViewController(root, animated: false)
        }

        return .one(flowContributor: .contribute(withNextPresentable: dashboardFlow,
                                                 withNextStepper: OneStepper(withSingleStep: BeerStep.TabBarIsRequired)))
    }
}

class AppStepper: Stepper {
    let steps = PublishRelay<Step>()

    var initialStep: Step {
        return BeerStep.TabBarIsRequired
    }
}
