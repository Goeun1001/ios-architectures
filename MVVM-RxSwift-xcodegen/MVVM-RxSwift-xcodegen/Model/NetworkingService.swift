//
//  NetworkAPI.swift
//  MVC-storyboard
//
//  Created by GoEun Jeong on 2021/04/28.
//

import Foundation
import RxSwift

protocol NetworkingService {
    func request(_ api: BeerAPI) -> Single<[Beer]>
}

enum NetworkingError: Error {
    case error(String)
    case defaultError
    
    var message: String {
        switch self {
        case let .error(msg):
            return msg
        case .defaultError:
            return "Please retry later."
        }
    }
}

final class NetworkingApi: NetworkingService {
    private let session = URLSession.shared
    
    private func setRequest(_ api: BeerAPI) -> URLRequest {
        var url = api.baseURL + api.path
        if api.querys != nil {
            url += "?"
            for query in api.querys! {
                url += query.key + "=" + query.value
            }
        }
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = api.method
        return request
    }
    
    func request(_ api: BeerAPI) -> Single<[Beer]> {
        return Single<[Beer]>.create { single in
            let response = self.session.rx.response(request: self.setRequest(api))
            
            return response.subscribe(onNext: { response, data in
                if 200..<300 ~= response.statusCode {
                    guard let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
                        return single(.error(NetworkingError.error("\(api.path) JSON 파싱 오류")))
                    }
                    
                    return single(.success(beers))
                }
            }, onError: { error in
                return single(.error(NetworkingError.defaultError))
            })
        }
    }
}
