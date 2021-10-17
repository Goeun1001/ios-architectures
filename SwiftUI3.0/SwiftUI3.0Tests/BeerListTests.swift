//
//  BeerListTests.swift
//  SwiftUI-MVVMTests
//
//  Created by GoEun Jeong on 2021/05/13.
//

import Foundation
import Moya
import XCTest

@testable import SwiftUI3_0

class BeerListTests: XCTestCase {
    var viewModel: BeerListViewModel!

    override func setUp() {
        viewModel = BeerListViewModel(networkingApi: MockNetworkingAPI())
    }

    func test_get_beer() {
        viewModel.apply(.getBeerList)

        XCTAssertEqual(viewModel.beers, Bundle.getBeerListJson())
    }

    func test_fail_network() {
        viewModel = BeerListViewModel(networkingApi: FailedNetworkingAPI())
        viewModel.apply(.getBeerList)

        XCTAssertEqual(viewModel.isErrorAlert, true)
        XCTAssertEqual(viewModel.errorMessage, "Failed to map Endpoint to a URLRequest.")
    }
}
