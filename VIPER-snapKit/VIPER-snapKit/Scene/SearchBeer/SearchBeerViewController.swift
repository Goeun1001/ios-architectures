//
//  SearchBeerViewController.swift
//  VIPER-snapKit
//
//  Created by GoEun Jeong on 2021/05/12.
//  
//

import UIKit
import RxSwift
import RxCocoa

class SearchBeerViewController: UIViewController, SearchBeerViewProtocol {
    
    // MARK: - Properties
    let presenter: SearchBeerPresenter
    private let beerView = BeerView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    
    init(presenter: SearchBeerPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.bindPresenter()
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
    
    private func bindPresenter() {
        searchController.searchBar.rx.text
            .orEmpty
            .filter { $0 != "" }
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: presenter.input.searchTrigger)
            .disposed(by: disposeBag)
        
        presenter.output.beer
            .subscribe(onNext: { [weak self] beer in
                self?.beerView.setupView(model: beer.first ?? Beer(id: nil, name: "Please Search Beer By ID", description: "", imageURL: ""))
            })
            .disposed(by: disposeBag)
        
        presenter.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] _ in
                self?.searchController.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
