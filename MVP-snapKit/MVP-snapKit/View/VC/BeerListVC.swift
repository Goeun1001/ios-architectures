//
//  BeerrListVC.swift
//  MVC-storyboard
//
//  Created by GoEun Jeong on 2021/04/28.
//

import UIKit

protocol BeerListView: AnyObject {
    func onItemsRetrieval(beers: [Beer])
    func onItemsReset(beers: [Beer])
}

class BeerListVC: UIViewController {
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var beers: [Beer] = []
    
    var presenter: BeerListViewPresenter!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        setupNavigationTitle()
        presenter.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSubview() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(resetView), for: .valueChanged)
        
        tableView.register(BeerTableViewCell.self, forCellReuseIdentifier: "BeerTableViewCell")
        
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
    
    @objc private func resetView() {
        activityIndicator.startAnimating()
        presenter.refresh()
        DispatchQueue.main.async { // Change UI
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
        }
    }
}

extension BeerListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return
            beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerTableViewCell") as! BeerTableViewCell
        
        cell.setupView(model: beers[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Int(scrollView.contentOffset.y) >= 1800 * presenter.getCurrentPage() { // Not Perfect ...
            presenter.getNextPage()
        }
        //        print(scrollView.contentOffset.y)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DetailBeerVC(beer: beers[indexPath.row])
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension BeerListVC: BeerListView {
    func onItemsRetrieval(beers: [Beer]) {
        self.beers += beers
        DispatchQueue.main.async { // Change UI
            self.activityIndicator.startAnimating()
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func onItemsReset(beers: [Beer]) {
        self.beers = beers
        DispatchQueue.main.async { // Change UI
            self.activityIndicator.startAnimating()
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}
