//
//  SearchBeerCoordinator.swift
//  MVVM-C-RxSwift-snapKit
//
//  Created by GoEun Jeong on 2021/05/04.
//

import Foundation
import UIKit

class SearchBeerCoordinator: BaseCoordinator {
    override func start() {
        let vc = UINavigationController(rootViewController: SearchBeerVC(coordinator: self))
        self.navigationController = vc
    }
    
}
