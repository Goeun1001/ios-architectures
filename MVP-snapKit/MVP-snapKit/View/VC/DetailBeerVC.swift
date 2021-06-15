//
//  DetailBeerVC.swift
//  MVP-snapKit
//
//  Created by GoEun Jeong on 2021/05/01.
//

import UIKit
import SnapKit

class DetailBeerVC: UIViewController {
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
