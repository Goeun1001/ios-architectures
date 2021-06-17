//
//  DetailBeerRouter.swift
//  RIBs-snapKit
//
//  Created by GoEun Jeong on 2021/06/17.
//

import RIBs

protocol DetailBeerInteractable: Interactable {
    var router: DetailBeerRouting? { get set }
    var listener: DetailBeerListener? { get set }
}

protocol DetailBeerViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class DetailBeerRouter: ViewableRouter<DetailBeerInteractable, DetailBeerViewControllable>, DetailBeerRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: DetailBeerInteractable, viewController: DetailBeerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
