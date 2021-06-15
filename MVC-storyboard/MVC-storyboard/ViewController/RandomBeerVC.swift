//
//  RandomBeerVC.swift
//  MVC-storyboard
//
//  Created by GoEun Jeong on 2021/04/28.
//

import UIKit
import Kingfisher

class RandomBeerVC: UIViewController {
    @IBOutlet private weak var beerImageView: UIImageView!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var networkingApi = NetworkingAPI()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRandom()
    }
    
    // MARK: - Private Methods
    
    private func getRandom() {
        activityIndicator.startAnimating()
        networkingApi.getRandomBeer(completion: { [weak self] beers in
            self?.setupView(model: beers.first ?? Beer(id: 0, name: "", description: "", imageURL: ""))
        })
        activityIndicator.stopAnimating()
    }
    
    private func setupView(model: Beer) {
        DispatchQueue.main.async { // Change UI 
            self.beerImageView.kf.setImage(with: URL(string: model.imageURL ?? ""))
            self.idLabel.text = String(model.id ?? 0)
            self.nameLabel.text =  model.name ?? ""
            self.descLabel.text = model.description ?? ""
        }
    }

    @IBAction private func rarndomButtonClicked(_ sender: Any) {
        self.getRandom()
    }
}
