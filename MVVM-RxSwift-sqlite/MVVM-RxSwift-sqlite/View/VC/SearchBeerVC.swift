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
    private let beerView = BeerView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let disposeBag = DisposeBag()
    private let viewModel = SearchBeerViewModel()
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                self?.beerView.setupView(model: beer.first ?? Beer(id: nil, name: "Please Search Beer By ID", description: "", imageURL: ""))
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.errorRelay
            .subscribe(onNext: { [weak self] error in
                self?.showErrorAlert(with: error.localizedDescription)
            }).disposed(by: disposeBag)
        
        searchController.searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] _ in
                self?.searchController.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
