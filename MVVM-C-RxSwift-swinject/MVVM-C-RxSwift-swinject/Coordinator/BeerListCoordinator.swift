//
//  BeerListCoordinator.swift
//  MVVM-C-RxSwift-snapKit
//
//  Created by GoEun Jeong on 2021/05/04.
//

import UIKit

class BeerListCoordinator: BaseCoordinator {
    override func start() {
        let vc = UINavigationController(rootViewController: BeerListVC(coordinator: self))
        self.navigationController = vc
    }
    
    func goDetail(beer: Beer) {
        let vc = DetailBeerVC(coordinator: self, beer: beer)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(vc, animated: true)
    }
}
