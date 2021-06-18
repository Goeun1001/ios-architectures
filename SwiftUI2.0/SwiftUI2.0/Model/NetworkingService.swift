//
//  NetworkingService.swift
//  SwiftUI-MV
//
//  Created by GoEun Jeong on 2021/05/12.
//

import Combine
import Moya

protocol NetworkingService {
    func request(_ api: BeerAPI) -> AnyPublisher<[Beer], MoyaError>
}

final class NetworkingAPI: NetworkingService {
    let provider: MoyaProvider<BeerAPI>

    init(provider: MoyaProvider<BeerAPI> = MoyaProvider<BeerAPI>()) {
        self.provider = provider
    }

    func request(_ api: BeerAPI) -> AnyPublisher<[Beer], MoyaError> {
        provider.requestPublisher(api)
            .map([Beer].self)
            .eraseToAnyPublisher()
    }
}
