//
//  BeerrListVC.swift
//  MVC-storyboard
//
//  Created by GoEun Jeong on 2021/04/28.
//

import UIKit

class BeerListVC: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()
    
    private var beers: [Beer] = []
    private var page = 1
    
    var networkingApi = NetworkingAPI()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        setupRefreshControl()
        getBeerList()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Private Methods
    
    private func registerXib() {
        let nibName = UINib(nibName: "BeerTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "BeerTableViewCell")
        tableView.rowHeight = 114
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(resetView), for: .valueChanged)
        tableView.addSubview(refreshControl)
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
        activityIndicator.startAnimating()
        networkingApi.getBeerList(page: self.page, completion: { [weak self] beers in
            self?.beers += beers
            DispatchQueue.main.async { // Change UI
                self?.tableView.reloadData()
            }
        })
        activityIndicator.stopAnimating()
    }
}

extension BeerListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return
            beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerTableViewCell") as? BeerTableViewCell else { return UITableViewCell() }
        
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
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailBeerVC") as! DetailBeerVC
        vc.beer = beers[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
