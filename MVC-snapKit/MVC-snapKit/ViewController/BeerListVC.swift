//
//  BeerrListVC.swift
//  MVC-storyboard
//
//  Created by GoEun Jeong on 2021/04/28.
//

import UIKit

class BeerListVC: UIViewController {
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var beers: [Beer] = []
    private var page = 1
    
    private let networkingApi: NetworkingService!
    
    // MARK: - Initialization
    
    init(networkingApi: NetworkingService = NetworkingAPI()) {
        self.networkingApi = networkingApi
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        setupNavigationTitle()
        getBeerList()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Private Methods
    
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
        networkingApi.getBeerList(page: 1, completion: { [weak self] beers in
            self?.beers = beers
            DispatchQueue.main.async { // Change UI
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        })
    }
    
    private func getBeerList() {
        self.activityIndicator.startAnimating()
        networkingApi.getBeerList(page: self.page, completion: { [weak self] beers in
            self?.beers += beers
            DispatchQueue.main.async { // Change UI
                self?.tableView.reloadData()
            }
        })
        self.activityIndicator.stopAnimating()
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
        if Int(scrollView.contentOffset.y) >= 1800 * self.page { // Not Perfect ...
            self.page += 1
            self.getBeerList()
        }
        //        print(scrollView.contentOffset.y)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DetailBeerVC(beer: beers[indexPath.row])
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
