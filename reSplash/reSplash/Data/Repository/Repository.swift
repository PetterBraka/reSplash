//
//  Repository.swift
//  reSplash
//
//  Created by Petter Vang Brakalsvalet on 03/06/2022.
//

import CoreData
import UIKit

enum CoreDataError: Error {
    case invalidManagedObjectType
    case elementNotFound
}

//class CoreDataRepository<<#ObjectModel#>: NSManagedObject>: Repository {
//    var persistanceController: PersistenceControllerProtocol
//    private let managedObjectContext: NSManagedObjectContext
//
//    init(context: NSManagedObjectContext,
//         persistanceController: PersistenceControllerProtocol) {
//        managedObjectContext = context
//        self.persistanceController = persistanceController
//    }
//
//    func create() async throws -> <#ObjectModel#> {
//        let className = String(describing: <#ObjectModel#>.self)
//        guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: className,
//                                                                      into: managedObjectContext) as? <#ObjectModel#>
//        else {
//            throw CoreDataError.invalidManagedObjectType
//        }
//        return managedObject
//    }
//
//    func delete(_ day: <#ObjectModel#>) {
//        managedObjectContext.delete(day)
//    }
//
//    func get(id: String,
//             predicate: NSPredicate?,
//             sortDescriptors: [NSSortDescriptor]?) async throws -> <#ObjectModel#> {
//        let entityName = String(describing: <#ObjectModel#>.self)
//        let request = NSFetchRequest<<#ObjectModel#>>(entityName: entityName)
//        request.sortDescriptors = sortDescriptors
//        request.predicate = predicate
//        request.predicate = NSPredicate(format: "id == %@", id)
//        guard let results = try? managedObjectContext.fetch(request) else {
//            throw CoreDataError.invalidManagedObjectType
//        }
//        guard let singleElement = results.first else {
//            throw CoreDataError.elementNotFound
//        }
//        return singleElement
//    }
//
//    func get(date: Date,
//             predicate: NSPredicate?,
//             sortDescriptors: [NSSortDescriptor]?) async throws -> <#ObjectModel#> {
//        let entityName = String(describing: <#ObjectModel#>.self)
//        let request = NSFetchRequest<<#ObjectModel#>>(entityName: entityName)
//        request.sortDescriptors = sortDescriptors
//        request.predicate = predicate
//        // Get day's beginning & tomorrows beginning time
//        let startOfDay = Calendar.current.startOfDay(for: date)
//        let startOfNextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)
//        // Sets conditions for date to be within day
//        let fromPredicate = NSPredicate(format: "date >= %@", startOfDay as NSDate)
//        let toPredicate = NSPredicate(format: "date < %@", startOfNextDay! as NSDate)
//        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates:
//                                                    [fromPredicate, toPredicate])
//        request.predicate = datePredicate
//        guard let results = try? managedObjectContext.fetch(request) else {
//            throw CoreDataError.elementNotFound
//        }
//        guard let singleElement = results.first else {
//            throw CoreDataError.elementNotFound
//        }
//        return singleElement
//    }
//
//    func getLastObject(predicate: NSPredicate?) async throws -> <#ObjectModel#>? {
//        let entityName = String(describing: <#ObjectModel#>.self)
//        let request = NSFetchRequest<<#ObjectModel#>>(entityName: entityName)
//        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
//        request.predicate = predicate
//        request.fetchLimit = 1
//
//        guard let results = try? managedObjectContext.fetch(request) else {
//            throw CoreDataError.invalidManagedObjectType
//        }
//        return results.first
//    }
//
//    func getAll(predicate: NSPredicate?,
//                sortDescriptors: [NSSortDescriptor]?) async throws -> [<#ObjectModel#>] {
//        let entityName = String(describing: <#ObjectModel#>.self)
//        let request = NSFetchRequest<<#ObjectModel#>>(entityName: entityName)
//        request.sortDescriptors = sortDescriptors
//        request.predicate = predicate
//        guard let result = try? managedObjectContext.fetch(request) else {
//            throw CoreDataError.invalidManagedObjectType
//        }
//        return result
//    }
//}
