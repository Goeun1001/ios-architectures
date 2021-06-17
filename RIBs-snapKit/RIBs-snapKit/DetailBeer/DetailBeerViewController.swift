//
//  DetailBeerViewController.swift
//  RIBs-snapKit
//
//  Created by GoEun Jeong on 2021/06/17.
//

import RIBs
import RxSwift
import UIKit
import RxCocoa

protocol DetailBeerPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class DetailBeerViewController: UIViewController, DetailBeerPresentable, DetailBeerViewControllable {
    
    weak var listener: DetailBeerPresentableListener?
    
    lazy var detachObservable: Observable<Void> = detachRelay.asObservable()
    
    // MARK: - Properties
    
    private let detachRelay: PublishRelay<Void> = .init()
    
    private let disposeBag: DisposeBag = .init()
    
    private let detailView = BeerView()
    private let beer: Beer

    // MARK: - Initialization

    init(beer: Beer) {
      self.beer = beer
      super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        detachRelay.accept(())
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Private Methods

    private func setupSubview() {
        view.backgroundColor = .white
        view.addSubview(detailView)
        detailView.setupView(model: beer)

        detailView.snp.makeConstraints {
            $0.top.equalTo(view.layoutMarginsGuide)
            $0.size.equalToSuperview()
        }
    }
}
