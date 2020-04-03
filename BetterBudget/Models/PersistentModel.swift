//
//  PersistentModel.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 4/1/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

/*
import Foundation
import CoreData

class PersistentModel {
    static let sharedInstance = PersistentModel()

    var container: NSPersistentContainer!
    var resultController: NSFetchRequestResult!
    var addExpenseModel: AddExpenseModel
    
    init() {
        addExpenseModel = AddExpenseModel()
        
        container = NSPersistentContainer(name: "ExpenseModel")
        
        container.loadPersistentStores { (_, error) in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unsolved error \(error.localizedDescription)")
            }
        }
    print(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).last! as String)
        
        importInitialData()
    }
    
    func importInitialData () {
        do {
            let fetchRequest: NSFetchRequest<Expense> = Expense.createFetchRequest()
            let result = try container.viewContext.fetch(fetchRequest)
            
            
        }
    }
    
}

 */
