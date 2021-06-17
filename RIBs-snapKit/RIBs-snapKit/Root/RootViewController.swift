//
//  RootViewController.swift
//  RIBs-snapKit
//
//  Created by GoEun Jeong on 2021/06/17.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootViewController: UINavigationController, RootPresentable, RootViewControllable {

    weak var listener: RootPresentableListener?

    func pushViewController(_ viewController: ViewControllable, animated: Bool) {
        self.navigationBar.isHidden = true
        pushViewController(viewController.uiviewController, animated: animated)
    }
}
