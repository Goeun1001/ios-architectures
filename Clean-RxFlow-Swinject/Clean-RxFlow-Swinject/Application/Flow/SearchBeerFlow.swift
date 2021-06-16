//
//  SearchBeer.swift
//  MVVM-RxSwift-snapKit
//
//  Created by GoEun Jeong on 2021/05/09.
//

import RxFlow
import UIKit

class SearchBeerFlow: Flow {
    @Inject var vc: SearchBeerVC
    
    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? BeerStep else { return .none }

        switch step {
        case .SearchBeerIsRequired:
            return navigateToSearchBeerScreen()
        case .alert(let string):
            return alert(string: string)
        default:
            return .none
        }
    }

    private func navigateToSearchBeerScreen() -> FlowContributors {
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func alert(string: String) -> FlowContributors {
        self.rootViewController.showErrorAlert(with: string)
        return .none
    }
}
