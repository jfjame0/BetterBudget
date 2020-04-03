//
//  ExpenseProvider.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 3/29/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import UIKit
import CoreData


class ExpenseProvider {
    private(set) var persistentContainer: NSPersistentContainer
    private weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    //Date formatter for recording the timestamp in the default post title
    //Change this so that it's a basic bill title of 'New Bill', and basic amount of '$0.00'
    private lazy var mediumTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "DD"
        return formatter
    }()
    
    init(with persistentContainer: NSPersistentContainer,
         fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?) {
        self.persistentContainer = persistentContainer
        self.fetchedResultsControllerDelegate = fetchedResultsControllerDelegate
    }
    
    //A fetched results controller for the Expense Entiity, sorted by title
    lazy var fetchedResultsController: NSFetchedResultsController<Expense> = {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Schema.Expense.title.rawValue, ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = fetchedResultsControllerDelegate
        
        do {
            try controller.performFetch()
        } catch {
            fatalError("###\(#function): Failed to performFetch: \(error)")
        }
        
        return controller
        
    }()
    
    func addExpense(in context: NSManagedObjectContext, shouldSave: Bool = true, completionHandler: ((_ newExpense: Expense) -> Void)? = nil) {
        context.perform {
            let expense = Expense(context: context)
            expense.title = "Untitled"
        
            if shouldSave {
                context.save(with: .addExpense)
            }
        completionHandler?(expense)
        }
        
    }
    
    func delete(expense: Expense, shouldSave: Bool = true, completionHandler: (() -> Void)? = nil) {
        guard let context = expense.managedObjectContext else {
            fatalError("###\(#function): Failed to retrieve the context from: \(expense)")
        }
        context.perform {
            context.delete(expense)
            
            if shouldSave {
                context.save(with: .deleteExpense)
            }
            completionHandler?()
        }
    }
}
