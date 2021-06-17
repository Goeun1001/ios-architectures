//
//  BeerListBuilder.swift
//  RIBs-snapKit
//
//  Created by GoEun Jeong on 2021/05/16.
//

import RIBs

protocol BeerListDependency: Dependency, DetailBeerDependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class BeerListComponent: Component<BeerListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol BeerListBuildable: Buildable {
    func build(withListener listener: BeerListListener) -> BeerListRouting
}

final class BeerListBuilder: Builder<BeerListDependency>, BeerListBuildable {

    override init(dependency: BeerListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: BeerListListener) -> BeerListRouting {
        let viewController = BeerListViewController()
        let interactor = BeerListInteractor(presenter: viewController)
        interactor.listener = listener
        let detailBeerBuilder = DetailBeerBuilder(dependency: dependency)
        return BeerListRouter(detailBeerBuilder: detailBeerBuilder, interactor: interactor, viewController: viewController)
    }
}
