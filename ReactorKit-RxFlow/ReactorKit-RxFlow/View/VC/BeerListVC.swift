//
//  BeerrListVC.swift
//  MVC-storyboard
//
//  Created by GoEun Jeong on 2021/04/28.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import ReactorKit

class BeerListVC: UIViewController, View {
    typealias Reactor = BeerListReactor
    
    private let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var disposeBag = DisposeBag()
    
    // MARK: - Table View
    
    private let dataSource = RxTableViewSectionedReloadDataSource<BeerListSection>(configureCell: {  (_, tableView, _, beer) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerTableViewCell") as? BeerTableViewCell ?? BeerTableViewCell(style: .default, reuseIdentifier: "BeerTableViewCell")
        cell.setupView(model: beer)
        return cell
    })
    
    // MARK: - Initialization
    
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: Reactor) {
        self.bindAction(reactor: reactor)
        self.bindState(reactor: reactor)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        setupNavigationTitle()
    }
    
    // MARK: - Private Methods
    
    private func setupSubview() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        tableView.addSubview(refreshControl)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupNavigationTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "BeerList"
        self.navigationItem.accessibilityLabel = "BeerList"
    }
    
    private func bindAction(reactor: Reactor) {
        self.rx.viewWillAppear.map{ _ in Void() }
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.reachedBottom(offset: 120.0)
            .map { _ in Reactor.Action.nextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Beer.self)
            .map { Reactor.Action.detailBeer($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] row in
                self?.tableView.deselectRow(at: row, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        tableView.delegate = nil
        tableView.dataSource = nil

        reactor.state.map { $0.list }
            .map { [BeerListSection(header: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isRefreshing }
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}
