//
//  AppComponent.swift
//  RIBs-snapKit
//
//  Created by GoEun Jeong on 2021/05/16.
//

import Foundation
import RIBs

class AppComponent: Component<EmptyDependency>, RootDependency {

    init() {
        super.init(dependency: EmptyComponent())
    }
}
