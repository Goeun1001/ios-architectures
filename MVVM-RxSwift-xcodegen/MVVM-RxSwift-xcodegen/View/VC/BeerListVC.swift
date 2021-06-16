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

class BeerListVC: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let disposeBag = DisposeBag()
    private let viewModel = BeerListViewModel()
    
    // MARK: - Table View
    
    private let dataSource = RxTableViewSectionedReloadDataSource<BeerListSection>(configureCell: {  (_, tableView, _, beer) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerTableViewCell") as? BeerTableViewCell ?? BeerTableViewCell(style: .default, reuseIdentifier: "BeerTableViewCell")
        cell.setupView(model: beer)
        return cell
    })
    
    private func registerXib() {
        let nibName = UINib(nibName: "BeerTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "BeerTableViewCell")
        tableView.rowHeight = 114
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        bindViewModel()
        registerXib()
    }
    
    private func setupSubview() {
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        tableView.addSubview(activityIndicator)
    }
    
    private func bindViewModel() {
        Observable.just(())
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.input.refreshTrigger)
            .disposed(by: disposeBag)
        
        viewModel.output.list
            .map { [BeerListSection(header: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .filter { !$0 }
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.isRefreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.output.errorRelay
            .subscribe(onNext: { [weak self] error in
                self?.showErrorAlert(with: error.message)
            }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Beer.self)
            .subscribe(onNext: { [weak self] beer in
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailBeerVC") as! DetailBeerVC
                vc.beer = beer
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] row in
                self?.tableView.deselectRow(at: row, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.reachedBottom(offset: 120.0)
            .bind(to: viewModel.input.nextPageTrigger)
            .disposed(by: disposeBag)
    }
}
