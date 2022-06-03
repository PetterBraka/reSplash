//
//  Persistence.swift
//  reSplash
//
//  Created by Petter Vang Brakalsvalet on 03/06/2022.
//

import CoreData

protocol PersistenceControllerProtocol {
    var container: NSPersistentContainer { get }
}

struct PersistenceController: PersistenceControllerProtocol {
    static func empty() -> PersistenceController {
        PersistenceController(inMemory: true)
    }

    var container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "com.braka.reSplash")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType
            .mergeByPropertyStoreTrumpMergePolicyType)
    }
}
