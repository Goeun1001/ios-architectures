//
//  RandomBeerTests.swift
//  SwiftUI-MVVMTests
//
//  Created by GoEun Jeong on 2021/05/13.
//

import Foundation
import XCTest

@testable import SwiftUI3_0

class RandomBeerTests: XCTestCase {
    var viewModel: RandomBeerViewModel!

    override func setUp() {
        viewModel = RandomBeerViewModel(networkingApi: MockNetworkingAPI())
    }

    func test_get_beer() {
        viewModel.apply(.getRandom)

        XCTAssertEqual(viewModel.beer, Bundle.getSingleBeerJson().first!)
    }

    func test_fail_network() {
        viewModel = RandomBeerViewModel(networkingApi: FailedNetworkingAPI())
        viewModel.apply(.getRandom)

        XCTAssertEqual(viewModel.isErrorAlert, true)
        XCTAssertEqual(viewModel.errorMessage, "Failed to map Endpoint to a URLRequest.")
    }
}
