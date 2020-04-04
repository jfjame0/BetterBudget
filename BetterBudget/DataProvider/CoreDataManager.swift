//
//  CoreDataManager.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 4/3/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CoreDataCloudKit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static var managedContext: NSManagedObjectContext {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension CoreDataManager {
    
    static func saveExpenseEntity(title: String?, amount: Double?, dueDate: Date?, repeats: String?, notes: String?) {
        
        let expense = Expense(context: managedContext)
        let context = expense.managedObjectContext!
        
        context.performAndWait {
            if let title = title,
                let amount = amount {
                expense.title = title
                expense.amount = Double(amount)
                expense.dueDate = dueDate
                expense.repeats = repeats
                expense.notes = notes
            } else {
                return //Put a Warning Alert
            }
        }
    }
}
