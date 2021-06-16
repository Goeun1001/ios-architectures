//
//  CoreDataManager.swift
//  MVVM-RxSwift-coreData
//
//  Created by GoEun Jeong on 2021/05/05.
//

import CoreData

protocol LocalManager {
    func saveBeer(beer: Beer)
    func getLocalBeerList(page: Int, completion: @escaping ((Result<[Beer], NetworkingError>) -> Void))
    func searchLocalID(id: Int, completion: @escaping ((Result<[Beer], NetworkingError>) -> Void))
    func localRandom(completion: @escaping ((Result<[Beer], NetworkingError>) -> Void))
}

class CoreDataManager: LocalManager {
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Beer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getLocalBeerList(page: Int,
                         completion: @escaping ((Result<[Beer], NetworkingError>) -> Void)) {
        var beers = [Beer]()
        for i in (page - 1) * 25 + 1 ... page * 25  {
            let predicate = NSPredicate(format: "id = %d", i)
            if let beerEntity = self.persistentContainer.viewContext.fetchData(predicate: predicate) as? [BeerEntity] {
                for beer in beerEntity {
                    beers.append(beer.toDTO())
                }
            } else { completion(.failure(NetworkingError.defaultError)) }
        }
        
        if beers.isEmpty {
            completion(.failure(NetworkingError.defaultError))
        } else {
            completion(.success(beers))
        }
    }
    
    func searchLocalID(id: Int, completion: @escaping ((Result<[Beer], NetworkingError>) -> Void)) {
        var beers = [Beer]()
        let predicate = NSPredicate(format: "id = %d", id)
        if let beerEntity = self.persistentContainer.viewContext.fetchData(predicate: predicate) as? [BeerEntity] {
            if !beerEntity.isEmpty { beers.append(beerEntity.first!.toDTO())}
        } else { }
        
        if beers.isEmpty {
            completion(.failure(NetworkingError.defaultError))
        } else {
            completion(.success(beers))
        }
    }
    
    func localRandom(completion: @escaping ((Result<[Beer], NetworkingError>) -> Void)) {
        var beers = [Beer]()
        let id = Int.random(in: 0...10)
        let predicate = NSPredicate(format: "id CONTAINS[cd] %d", id)
        if let beerEntity = self.persistentContainer.viewContext.fetchData(predicate: predicate) as? [BeerEntity] {
            if !beerEntity.isEmpty { beers.append(beerEntity.first!.toDTO())}
        } else { }
        
        if beers.isEmpty {
            completion(.failure(NetworkingError.defaultError))
        } else {
            completion(.success(beers))
        }
    }
    
    func saveBeer(beer: Beer) {
        self.persistentContainer.performBackgroundTask { context in
            do {
                self.deleteResponse(id: beer.id ?? 0, in: context)
                
                _ = beer.toEntity(in: context)

                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataMoviesResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    
    func resetData() {
        let context = persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: BeerEntity.raw())
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func fetchRequest(id: Int) -> NSFetchRequest<BeerEntity> {
        let request: NSFetchRequest = BeerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", id)
        return request
    }
    
    private func deleteResponse(id: Int, in context: NSManagedObjectContext) {
        let request = fetchRequest(id: id)
        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
    
}

extension NSManagedObjectContext {
    
    func fetchData(predicate: NSPredicate? = nil) -> Array<Any> {
        let request: NSFetchRequest = BeerEntity.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        // If predicate found then filter based on that
        if let predicate = predicate {
            request.predicate = predicate
        }
        do {
            let result = try self.fetch(request)
            return result
        } catch {
            fatalError("Failed to fetch BeerEntity: \(error)")
        }
    }
}

