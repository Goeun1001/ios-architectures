//
//  DetailBeerBuilder.swift
//  RIBs-snapKit
//
//  Created by GoEun Jeong on 2021/06/17.
//

import RIBs

protocol DetailBeerDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class DetailBeerComponent: Component<DetailBeerDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol DetailBeerBuildable: Buildable {
    func build(withListener listener: DetailBeerListener, beer: Beer) -> DetailBeerRouting
}

final class DetailBeerBuilder: Builder<DetailBeerDependency>, DetailBeerBuildable {

    override init(dependency: DetailBeerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DetailBeerListener, beer: Beer) -> DetailBeerRouting {
        let viewController = DetailBeerViewController(beer: beer)
        let interactor = DetailBeerInteractor(presenter: viewController)
        interactor.listener = listener
        return DetailBeerRouter(interactor: interactor, viewController: viewController)
    }
}
