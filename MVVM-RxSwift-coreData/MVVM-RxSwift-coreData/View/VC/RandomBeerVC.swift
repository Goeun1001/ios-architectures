//
//  RandomBeerVC.swift
//  MVC-storyboard
//
//  Created by GoEun Jeong on 2021/04/28.
//

import UIKit
import RxSwift
import RxCocoa
import Then

class RandomBeerVC: UIViewController {
    private let randomView = BeerView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let disposeBag = DisposeBag()
    private let viewModel = RandomBeerViewModel()
    
    private let randomButton = UIButton().then {
        $0.setTitle("Roll Random", for: .normal)
        $0.backgroundColor = UIColor.orange
    }
    
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
    
    private func bindViewModel() {
        self.rx.viewDidLoad
            .bind(to: viewModel.input.buttonTrigger)
            .disposed(by: disposeBag)
        
        randomButton.rx.tap
            .bind(to: viewModel.input.buttonTrigger)
            .disposed(by: disposeBag)
        
        viewModel.output.beer
            .subscribe(onNext: { [weak self] beer in
                self?.randomView.setupView(model: beer.first ?? Beer(id: nil, name: "Loading...", description: "", imageURL: ""))
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.errorRelay
            .subscribe(onNext: { [weak self] error in
                self?.showErrorAlert(with: error.message)
            }).disposed(by: disposeBag)
    }
}
