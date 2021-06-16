//
//  CoreDataManagerTests.swift
//  MVVM-RxSwift-coreDataTests
//
//  Created by GoEun Jeong on 2021/05/10.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import Nimble
import CoreData

@testable import MVVM_RxSwift_coreData

class CoreDataManagerTests: XCTestCase {
    let coreDataManager = CoreDataManager()
    let jsonBeers = Bundle.getBeerFromJson(.getBeerList(page: 1))
    
    override func setUp() {
        coreDataManager.resetData()
        for beer in jsonBeers {
            coreDataManager.saveBeer(beer: beer)
        }
    }
    
    func test_beerList_coreData_save() {
        var coreDataBeers = [Beer]()
        
        coreDataManager.getLocalBeerList(page: 1) { result in
            switch result {
            case .success(let beers):
                coreDataBeers = beers
            case .failure: break
            }
        }
        
        expect(self.jsonBeers).toEventually(contain(coreDataBeers))
    }
    
    func test_SearchBeer_coreData_save() {
        var coreDataBeers = [Beer]()
        
        coreDataManager.searchLocalID(id: 3) { result in
            switch result {
            case .success(let beers):
                coreDataBeers = beers
            case .failure: print("ERROR")
            }
        }
        
        expect(self.jsonBeers[2]).to(equal(coreDataBeers.first!))
    }
    
    func test_RandomBeer_coreData_save() {
        var coreDataBeers = [Beer]()
        
        coreDataManager.localRandom { result in
            switch result {
            case .success(let beers):
                coreDataBeers = beers
            case .failure: break
            }
        }
        
        expect(self.jsonBeers).toEventually(contain(coreDataBeers))
        
    }
}
