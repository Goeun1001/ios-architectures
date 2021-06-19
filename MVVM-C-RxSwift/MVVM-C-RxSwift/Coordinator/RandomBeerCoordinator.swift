//
//  RandomBeerCoordinator.swift
//  MVVM-C-RxSwift-snapKit
//
//  Created by GoEun Jeong on 2021/05/04.
//

import Foundation
import UIKit

class RandomBeerCoordinator: BaseCoordinator {
    override func start() {
        let vc = UINavigationController(rootViewController: RandomBeerVC(coordinator: self))
        self.navigationController = vc
    }
    
}
