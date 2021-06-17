//
//  BeerListInteractor.swift
//  RIBs-snapKit
//
//  Created by GoEun Jeong on 2021/05/16.
//

import RIBs
import RxSwift
import RxCocoa

protocol BeerListRouting: ViewableRouting {
    func showAlert(string: String)
    func attachBeerDetailRIB(beer: Beer)
    func detachBeerDetailRIB()
}

protocol BeerListPresentableInput: AnyObject {
    var viewLoadTrigger: Observable<Void> { get }
    var refreshTrigger: Observable<Void> { get }
    var nextPageTrigger: Observable<Void> { get }
    var goDetailTrigger: Observable<Beer> { get }
}

protocol BeerListPresentableOutput: AnyObject {
    var list: BehaviorRelay<[Beer]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var isRefreshing: PublishRelay<Bool> { get }
}

protocol BeerListPresentable: Presentable {
    var listener: BeerListPresentableListener? { get set }
    
    var input: BeerListPresentableInput? { get set }
    var output: BeerListPresentableOutput? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol BeerListListener: AnyObject {
}

final class BeerListInteractor: PresentableInteractor<BeerListPresentable>, BeerListInteractable, BeerListPresentableListener {

    weak var router: BeerListRouting?
    weak var listener: BeerListListener?
    
    private var page = 1
    private var disposeBag = DisposeBag()
    private let networkingApi: NetworkingService!
    
    private let beerListRelay = BehaviorRelay<[Beer]>(value: [Beer]())
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let isRefreshingRelay = PublishRelay<Bool>()
    
    // MARK: - ViewModelType
    
    init(presenter: BeerListPresentable, networkingApi: NetworkingService = NetworkingAPI()) {
        self.networkingApi = networkingApi
        super.init(presenter: presenter)
        presenter.listener = self
        presenter.output = self
        
        let activityIndicator = ActivityIndicator()
        let refreshIndicator = ActivityIndicator()
        
        guard let input = presenter.input else { return }
        
        input.viewLoadTrigger
            .asObservable()
            .flatMapLatest {
                networkingApi.request(.getBeerList(page: self.page))
                    .trackActivity(activityIndicator)
                    .do(onError: { self.router?.showAlert(string: $0.localizedDescription) })
                    .catchErrorJustReturn([])
            }
            .bind(to: self.beerListRelay)
            .disposed(by: disposeBag)
        
        input.refreshTrigger
            .asObservable()
            .map { self.page = 1 }
            .flatMapLatest {
                networkingApi.request(.getBeerList(page: self.page))
                    .trackActivity(refreshIndicator)
                    .do(onError: { self.router?.showAlert(string: $0.localizedDescription) })
                    .catchErrorJustReturn([])
            }
            .bind(to: self.beerListRelay)
            .disposed(by: disposeBag)
        
        
        input.nextPageTrigger
            .asObservable()
            .map { self.page += 1 }
            .flatMapLatest {
                networkingApi.request(.getBeerList(page: self.page))
                    .trackActivity(activityIndicator)
                    .do(onError: { self.router?.showAlert(string: $0.localizedDescription) })
                    .catchErrorJustReturn([])
            }
            .map { self.beerListRelay.value + $0 }
            .bind(to: self.beerListRelay)
            .disposed(by: disposeBag)
        
        input.goDetailTrigger
            .subscribe(onNext: { [weak self] beer in
                self?.router?.attachBeerDetailRIB(beer: beer)
            }).disposed(by: disposeBag)
        
        activityIndicator
            .asObservable()
            .bind(to: self.isLoadingRelay)
            .disposed(by: disposeBag)
        
        refreshIndicator
            .asObservable()
            .bind(to: self.isRefreshingRelay)
            .disposed(by: disposeBag)
    }
}

// MARK: - DetailBeerListener
extension BeerListInteractor {
    func detachDetailBeerRIB() {
        router?.detachBeerDetailRIB()
    }
}


extension BeerListInteractor: BeerListPresentableOutput {
    var list: BehaviorRelay<[Beer]> { return beerListRelay }
    
    var isLoading: BehaviorRelay<Bool> { return isLoadingRelay }
    
    var isRefreshing: PublishRelay<Bool> { return isRefreshingRelay }

}
