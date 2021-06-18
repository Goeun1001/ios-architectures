//
//  BeerAPI.swift
//  SwiftUI-MV
//
//  Created by GoEun Jeong on 2021/05/12.
//

import Moya

enum BeerAPI {
    case getBeerList(page: Int)
    case getDetailBeer(id: Int)
    case searchID(id: Int)
    case random
}

extension BeerAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.punkapi.com/v2/beers")!
    }

    var path: String {
        switch self {
        case .random:
            return "/random"
        default:
            return ""
        }
    }

    var method: Method {
        return .get
    }

    var task: Task {
        switch self {
        case let .getBeerList(page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case let .searchID(id):
            return .requestParameters(parameters: ["ids": id], encoding: URLEncoding.queryString)
        case let .getDetailBeer(id):
            return .requestParameters(parameters: ["ids": id], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }

    var sampleData: Data {
        switch self {
        case .getBeerList:
            return stubbedResponse("BeerList")
        case .random:
            return stubbedResponse("RandomBeer")
        case .searchID, .getDetailBeer:
            return stubbedResponse("SingleBeer")
        }
    }

    var headers: [String: String]? {
        return nil
    }

    func stubbedResponse(_ filename: String) -> Data! {
        let bundlePath = Bundle.main.path(forResource: "Stub", ofType: "bundle")
        let bundle = Bundle(path: bundlePath!)
        let path = bundle?.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }
}
