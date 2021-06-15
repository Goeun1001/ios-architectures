//
//  TabBarVC.swift
//  MVC-snapKit
//
//  Created by GoEun Jeong on 2021/04/29.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        configureTabBarItems()
    }

    private func configureTabBarItems() {
        let listVC = BeerListVC()
        let listPresenter = BeerListPresenter(view: listVC)
        listVC.presenter = listPresenter
        listVC.tabBarItem = UITabBarItem(title: "Beer List", image: UIImage(systemName: "1.circle"), tag: 0)

        let searchVC = SearchBeerVC()
        let searchPresenter = SearchBeerPresenter(view: searchVC)
        searchVC.presenter = searchPresenter
        searchVC.tabBarItem = UITabBarItem(title: "Search ID", image: UIImage(systemName: "2.circle"), tag: 1)
        
        let randomVC = RandomBeerVC()
        let randomPresenter = RandomBeerPresenter(view: randomVC)
        randomVC.presenter = randomPresenter
        randomVC.tabBarItem = UITabBarItem(title: "Random", image: UIImage(systemName: "3.circle"), tag: 2)

        let listNavigationVC = UINavigationController(rootViewController: listVC)
        let searchNavigationVC = UINavigationController(rootViewController: searchVC)
        let randomNavigationVC = UINavigationController(rootViewController: randomVC)
        setViewControllers([listNavigationVC, searchNavigationVC, randomNavigationVC], animated: false)
    }
}
