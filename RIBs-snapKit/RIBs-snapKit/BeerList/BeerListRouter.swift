//
//  BeerListRouter.swift
//  RIBs-snapKit
//
//  Created by GoEun Jeong on 2021/05/16.
//

import RIBs

protocol BeerListInteractable: Interactable, DetailBeerListener {
    var router: BeerListRouting? { get set }
    var listener: BeerListListener? { get set }
}

protocol BeerListViewControllable: ViewControllable {
    func pushViewController(_ viewController: ViewControllable, animated: Bool)
    func popViewController(animated: Bool)
}

final class BeerListRouter: ViewableRouter<BeerListInteractable, BeerListViewControllable>, BeerListRouting {
    
    private let detailBeerBuilder: DetailBeerBuildable
    private var detailBeerRouter: DetailBeerRouting?

    // TODO: Constructor inject child builder protocols to allow building children.
    init(detailBeerBuilder: DetailBeerBuildable, interactor: BeerListInteractable, viewController: BeerListViewControllable) {
        self.detailBeerBuilder = detailBeerBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func showAlert(string: String) {
        self.viewController.uiviewController.showErrorAlert(with: string)
    }
}

// MARK: - DetailRouting
extension BeerListRouter {
    func attachBeerDetailRIB(beer: Beer) {
        let router = detailBeerBuilder.build(withListener: interactor, beer: beer)
        detailBeerRouter = router
        attachChild(router)
        print("ATTACH")
        viewController.pushViewController(router.viewControllable, animated: true)
    }
    
    func detachBeerDetailRIB() {
        guard let router = detailBeerRouter else { return }
        viewController.popViewController(animated: true)
        detachChild(router)
        print("DETACH")
        detailBeerRouter = nil
    }
}
