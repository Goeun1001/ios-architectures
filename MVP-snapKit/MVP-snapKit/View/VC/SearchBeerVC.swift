//
//  SearchBeerVC.swift
//  MVC-storyboard
//
//  Created by GoEun Jeong on 2021/04/28.
//

import UIKit

protocol SearchView: AnyObject {
    func onItemsRetrieval(beers: [Beer])
}

class SearchBeerVC: UIViewController {
    private let beerView = BeerView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    var presenter: SearchBeerViewPresenter!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        setupNavigationTitle()
        setupSearch()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Search By ID"
        self.navigationItem.accessibilityLabel = "Search By Beer ID"
    }
    
    private func setupSearch() {
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.keyboardType = .numberPad
    }
    
    private func setupSubview() {
        view.backgroundColor = .white
        view.addSubview(beerView)
        view.addSubview(activityIndicator)
        
        beerView.snp.makeConstraints {
            $0.top.equalTo(view.layoutMarginsGuide)
            $0.size.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}

extension SearchBeerVC: UISearchResultsUpdating, SearchView {
    func onItemsRetrieval(beers: [Beer]) {
        activityIndicator.startAnimating()
        self.beerView.setupView(model: beers.first!)
        activityIndicator.stopAnimating()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != "" {
            activityIndicator.startAnimating()
            self.presenter.search(id: Int(searchController.searchBar.text!) ?? 0)
            activityIndicator.stopAnimating()
        }
    }
}
