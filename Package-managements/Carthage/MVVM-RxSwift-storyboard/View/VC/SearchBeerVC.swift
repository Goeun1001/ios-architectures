//
//  SearchBeerVC.swift
//  MVC-storyboard
//
//  Created by GoEun Jeong on 2021/04/28.
//

import UIKit
import RxSwift
import RxCocoa

class SearchBeerVC: UIViewController {
    @IBOutlet private weak var beerImageView: UIImageView!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private let searchController = UISearchController(searchResultsController: nil)
    private let disposeBag = DisposeBag()
    private let viewModel = SearchBeerViewModel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        setupNavigationTitle()
        setupSearch()
        bindViewModel()
    }
    
    private func setupNavigationTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Search By ID"
        self.navigationItem.accessibilityLabel = "Search By Beer ID"
    }
    
    private func setupSearch() {
        self.navigationItem.searchController = searchController
        searchController.searchBar.keyboardType = .numberPad
    }
    
    private func setupSubview() {
        view.backgroundColor = .white
        view.addSubview(activityIndicator)
    }
    
    func setupView(model: Beer) {
        DispatchQueue.main.async {
            self.beerImageView.kf.setImage(with: URL(string: model.imageURL ?? ""))
            self.idLabel.text = String(model.id ?? 0)
            self.nameLabel.text =  model.name ?? ""
            self.descLabel.text = model.description ?? ""
        }
    }
    
    private func bindViewModel() {
        searchController.searchBar.rx.text
            .orEmpty
            .filter { $0 != "" }
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.input.searchTrigger)
            .disposed(by: disposeBag)
        
        viewModel.output.beer
            .subscribe(onNext: { [weak self] beer in
                self?.setupView(model: beer.first ?? Beer(id: nil, name: "Please Search Beer By ID", description: "", imageURL: ""))
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.errorRelay
            .subscribe(onNext: { [weak self] error in
                self?.showErrorAlert(with: error.message)
            }).disposed(by: disposeBag)
        
        searchController.searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] _ in
                self?.searchController.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
