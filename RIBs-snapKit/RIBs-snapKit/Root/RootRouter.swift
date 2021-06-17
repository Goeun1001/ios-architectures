//
//  RootRouter.swift
//  RIBs-snapKit
//
//  Created by GoEun Jeong on 2021/06/17.
//

import RIBs

protocol RootInteractable: Interactable, TabBarListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func pushViewController(_ viewController: ViewControllable, animated: Bool)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    
    // MARK: - Properties
    
    private let tabbarBuilder: TabBarBuildable

    // TODO: Constructor inject child builder protocols to allow building children.
    init(tabbarBuilder: TabBarBuildable, interactor: RootInteractable, viewController: RootViewControllable) {
        self.tabbarBuilder = tabbarBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: - Overridden: LaunchRouter
    
    override func didLoad() {
        super.didLoad()
        
        attachTabbarRIB()
    }
    
    // MARK: - Private methods
    
    private func attachTabbarRIB() {
        let router = tabbarBuilder.build(withListener: interactor)
        attachChild(router)
        viewController.pushViewController(router.viewControllable, animated: false)
    }
}
