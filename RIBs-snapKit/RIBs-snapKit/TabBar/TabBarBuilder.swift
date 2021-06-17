//
//  TabBarBuilder.swift
//  RIBs-snapKit
//
//  Created by GoEun Jeong on 2021/05/16.
//

import RIBs

protocol TabBarDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TabBarComponent: Component<TabBarDependency> {
}

extension TabBarComponent: BeerListDependency, RandomBeerDependency, SearchBeerDependency {}


// MARK: - Builder

protocol TabBarBuildable: Buildable {
    func build(withListener listener: TabBarListener) -> TabBarRouting
}

final class TabBarBuilder: Builder<TabBarDependency>, TabBarBuildable {
    
    override init(dependency: TabBarDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: TabBarListener) -> TabBarRouting {
        let viewController = TabBarViewController()
        let component = TabBarComponent(dependency: dependency)
        let interactor = TabBarInteractor(presenter: viewController)
        
        let beerListBuilder = BeerListBuilder(dependency: component)
        let randomBeerBuilder = RandomBeerBuilder(dependency: component)
        let searchBeerBuilder = SearchBeerBuilder(dependency: component)
        return TabBarRouter(interactor: interactor,
                            viewController: viewController,
                            beerListBuilder: beerListBuilder,
                            randomBeerBuilder: randomBeerBuilder,
                            searchBeerBuilder: searchBeerBuilder)
    }
}
