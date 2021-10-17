//
//  RandomBeerViewController.swift
//  VIPER-snapKit
//
//  Created by GoEun Jeong on 2021/05/12.
//  
//

import UIKit
import RxSwift
import RxCocoa

class RandomBeerViewController: UIViewController, RandomBeerViewProtocol {
    
    // MARK: - Properties
    let presenter: RandomBeerPresenter
    
    private let randomView = BeerView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let disposeBag = DisposeBag()
    
    private let randomButton = UIButton().then {
        $0.setTitle("Roll Random", for: .normal)
        $0.backgroundColor = UIColor.orange
    }
    
    // MARK: - Initialization
    
    init(presenter: RandomBeerPresenter) {
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
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Random Beer"
        self.navigationItem.accessibilityLabel = "Random by Button"
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
    }
    
    private func bindPresenter() {
        self.rx.viewDidLoad
            .bind(to: presenter.input.buttonTrigger)
            .disposed(by: disposeBag)
        
        randomButton.rx.tap
            .bind(to: presenter.input.buttonTrigger)
            .disposed(by: disposeBag)
        
        presenter.output.beer
            .subscribe(onNext: { [weak self] beer in
                self?.randomView.setupView(model: beer.first ?? Beer(id: nil, name: "Loading...", description: "", imageURL: ""))
            })
            .disposed(by: disposeBag)
        
        presenter.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
