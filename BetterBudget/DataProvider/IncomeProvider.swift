//
//  IncomeProvider.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 3/29/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import UIKit
import CoreData


class IncomeProvider {
    private(set) var persistentContainer: NSPersistentContainer
    private weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    //Date formatter for recording the timestamp in the default post title
    
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
    
    //A fetched results controller for the Income Entiity, sorted by title
    lazy var fetchedResultsController: NSFetchedResultsController<Income> = {
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Schema2.Income.title.rawValue, ascending: true)]
        
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
    
    func addIncome(in context: NSManagedObjectContext, shouldSave: Bool = true, completionHandler: ((_ newIncome: Income) -> Void)? = nil) {
        context.perform {
            let income = Income(context: context)
            income.title = "* New Income Source *"
            
            if shouldSave {
                context.save(with: .addIncome)
            }
            completionHandler?(income)
        }
        
    }
    
    func delete(income: Income, shouldSave: Bool = true, completionHandler: (() -> Void)? = nil) {
        guard let context = income.managedObjectContext else {
            fatalError("###\(#function): Failed to retrieve the context from: \(income)")
        }
        context.perform {
            context.delete(income)
            
            if shouldSave {
                context.save(with: .deleteIncome)
            }
            completionHandler?()
        }
    }
}
