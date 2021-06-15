//
//  SearchBeerVC.swift
//  MVC-storyboard
//
//  Created by GoEun Jeong on 2021/04/28.
//

import UIKit

class SearchBeerVC: UIViewController {
    @IBOutlet private weak var beerImageView: UIImageView!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var networkingApi = NetworkingAPI()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
    }
    
    // MARK: - Private Methods
    
    private func setupView(model: Beer) {
        DispatchQueue.main.async { // Change UI 
            self.beerImageView.kf.setImage(with: URL(string: model.imageURL ?? ""))
            self.idLabel.text = String(model.id ?? 0)
            self.nameLabel.text =  model.name ?? ""
            self.descLabel.text = model.description ?? ""
        }
    }
    
    private func setupSearch() {
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.keyboardType = .numberPad
    }
    
}

extension SearchBeerVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != "" {
            activityIndicator.startAnimating()
            networkingApi.searchBeer(id: Int(searchController.searchBar.text!)!, completion: { [weak self] beers in
                self?.setupView(model: beers.first ?? Beer(id: 0, name: "", description: "", imageURL: ""))
            })
            activityIndicator.stopAnimating()
        }
    }
    
}
