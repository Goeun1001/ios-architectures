//
//  BeerEntity.swift
//  MVVM-RxSwift-coreData
//
//  Created by GoEun Jeong on 2021/05/05.
//

import Foundation
import CoreData

extension Beer {
    func toEntity(in context: NSManagedObjectContext) -> BeerEntity {
        let entity: BeerEntity = .init(context: context)
        entity.id = Int16(id ?? 0)
        entity.name = name
        entity.desc = description
        entity.imageURL = imageURL
        return entity
    }
}

extension BeerEntity {
    func toDTO() -> Beer {
        return .init(id: Int(id), name: name, description: desc, imageURL: imageURL)
    }
    
    static func raw() -> String {
        return "BeerEntity"
    }
}
