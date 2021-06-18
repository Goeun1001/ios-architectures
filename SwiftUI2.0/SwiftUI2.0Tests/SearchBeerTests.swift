//
//  SearchBeerTests.swift
//  SwiftUI-MVVMTests
//
//  Created by GoEun Jeong on 2021/05/13.
//

import Foundation
import XCTest

@testable import SwiftUI2_0

class SearchBeerTests: XCTestCase {
    var viewModel: SearchBeerViewModel!

    override func setUp() {
        viewModel = SearchBeerViewModel(networkingApi: MockNetworkingAPI())
    }

    func test_get_beer() {
        viewModel.text = "1"
        viewModel.apply(.search)

        XCTAssertEqual(viewModel.beer, Bundle.getSingleBeerJson().first!)
    }

    func test_fail_network() {
        viewModel = SearchBeerViewModel(networkingApi: FailedNetworkingAPI())
        viewModel.text = "1"
        viewModel.apply(.search)

        XCTAssertEqual(viewModel.isErrorAlert, true)
        XCTAssertEqual(viewModel.errorMessage, "Failed to map Endpoint to a URLRequest.")
    }
}
