//
//  BeerListViewController.swift
//  RIBs-snapKit
//
//  Created by GoEun Jeong on 2021/05/16.
//

import RIBs
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

protocol BeerListPresentableListener: AnyObject {
}

final class BeerListViewController: UIViewController, BeerListPresentable, BeerListViewControllable {
    weak var listener: BeerListPresentableListener?
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let disposeBag = DisposeBag()
    var input: BeerListPresentableInput?
    var output: BeerListPresentableOutput?
    
    // MARK: - Table View
    
    private let dataSource = RxTableViewSectionedReloadDataSource<BeerListSection>(configureCell: {  (_, tableView, _, beer) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerTableViewCell") as? BeerTableViewCell ?? BeerTableViewCell(style: .default, reuseIdentifier: "BeerTableViewCell")
        cell.setupView(model: beer)
        return cell
    })
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        input = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        setupNavigationTitle()
        self.bindOutput()
    }
    
    // MARK: - Private Methods
    
    private func setupSubview() {
        view.backgroundColor = .white
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
    
    func pushViewController(_ viewController: ViewControllable, animated: Bool) {
        viewController.uiviewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController.uiviewController, animated: animated)
    }
    
    func popViewController(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
}

extension BeerListViewController: BeerListPresentableInput {
    var viewLoadTrigger: Observable<Void> {
        return self.rx.viewDidLoad.asObservable()
    }
    
    var refreshTrigger: Observable<Void> {
        return refreshControl.rx.controlEvent(.valueChanged).asObservable()
    }
    
    var nextPageTrigger: Observable<Void> {
        return tableView.rx.reachedBottom(offset: 120.0).asObservable()
    }
    
    var goDetailTrigger: Observable<Beer> {
        return tableView.rx.modelSelected(Beer.self).asObservable()
    }
}

extension BeerListViewController {
    
    private func bindOutput() {
        guard let output = output else { return }
        
        output.list
            .map { [BeerListSection(header: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.isRefreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { self.tableView.deselectRow(at: $0, animated: true)})
            .disposed(by: disposeBag)
        
    }
}
