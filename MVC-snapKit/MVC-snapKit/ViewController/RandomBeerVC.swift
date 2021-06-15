//
//  RandomBeerVC.swift
//  MVC-storyboard
//
//  Created by GoEun Jeong on 2021/04/28.
//

import UIKit
import Kingfisher

class RandomBeerVC: UIViewController {
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let randomView = BeerView()
    private let networkingApi: NetworkingService!
    
    private lazy var randomButton: UIButton = {
        let randomButton = UIButton()
        randomButton.setTitle("Roll Random", for: .normal)
        randomButton.backgroundColor = UIColor.orange
        return randomButton
    }()
    
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
        getRandom()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Random Beer"
        self.navigationItem.accessibilityLabel = "Random by Button"
    }
    
    private func getRandom() {
        self.activityIndicator.startAnimating()
        networkingApi.getRandomBeer(completion: { [weak self] beers in
            self?.randomView.setupView(model: beers.first ?? Beer(id: 0, name: "", description: "", imageURL: ""))
        })
        self.activityIndicator.stopAnimating()
    }
    
    private func setupSubview() {
        view.backgroundColor = .white
        view.addSubview(randomView)
        view.addSubview(activityIndicator)
        randomView.addSubview(randomButton)
        
        randomView.snp.makeConstraints {
            $0.top.equalTo(view.layoutMarginsGuide)
            $0.size.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        randomButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.layoutMarginsGuide).offset(-30)
            $0.width.equalTo(view.snp.width).offset(-30)
            $0.height.equalTo(40)
        }
        
        randomButton.addTarget(self, action: #selector(randomButtonTapped), for: .touchUpInside)
    }
    
    @objc private func randomButtonTapped() {
        getRandom()
    }
}
