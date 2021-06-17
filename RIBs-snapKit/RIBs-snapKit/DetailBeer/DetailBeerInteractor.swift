//
//  DetailBeerInteractor.swift
//  RIBs-snapKit
//
//  Created by GoEun Jeong on 2021/06/17.
//

import RIBs
import RxSwift

protocol DetailBeerRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol DetailBeerPresentable: Presentable {
    var listener: DetailBeerPresentableListener? { get set }
    
    var detachObservable: Observable<Void> { get }
}

protocol DetailBeerListener: AnyObject {
    func detachDetailBeerRIB()
}

final class DetailBeerInteractor: PresentableInteractor<DetailBeerPresentable>, DetailBeerInteractable, DetailBeerPresentableListener {

    weak var router: DetailBeerRouting?
    weak var listener: DetailBeerListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: DetailBeerPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        bindPresenter()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

// MARK: - Binding
private extension DetailBeerInteractor {
    func bindPresenter() {
        presenter.detachObservable
            .bind { [weak self] _ in
                self?.listener?.detachDetailBeerRIB()
            }
            .disposeOnDeactivate(interactor: self)
    }
}
