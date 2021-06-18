//
//  Beer.swift
//  SwiftUI-MV
//
//  Created by GoEun Jeong on 2021/05/12.
//

import Foundation

struct Beer: Codable, Equatable {
    var id: Int?
    var name: String?
    var description: String?
    var imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageURL = "image_url"
    }
}
