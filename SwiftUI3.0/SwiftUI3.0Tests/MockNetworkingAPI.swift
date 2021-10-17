//
//  MockNetworkingPAI.swift
//  MVVM-RxSwift-snapKitTests
//
//  Created by GoEun Jeong on 2021/04/30.
//

import Combine
import Foundation
import Moya

@testable import SwiftUI3_0

class MockNetworkingAPI: NetworkingService {
    func getBeerFromJson(_ api: BeerAPI) -> [Beer] {
        let bundlePath = Bundle.main.path(forResource: "Stub", ofType: "bundle")
        let bundle = Bundle(path: bundlePath!)
        switch api {
        case .getBeerList:
            return bundle!.decode([Beer].self, from: "BeerList.json")
        default:
            return bundle!.decode([Beer].self, from: "SingleBeer.json")
        }
    }

    func request(_ api: BeerAPI) -> AnyPublisher<[Beer], MoyaError> {
        return Just(getBeerFromJson(api))
            .setFailureType(to: MoyaError.self)
            .eraseToAnyPublisher()
    }
}

class FailedNetworkingAPI: NetworkingService {
    func request(_: BeerAPI) -> AnyPublisher<[Beer], MoyaError> {
        return Fail(error: MoyaError.requestMapping(""))
            .eraseToAnyPublisher()
    }
}
