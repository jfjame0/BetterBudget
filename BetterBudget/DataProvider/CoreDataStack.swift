//
//  CoreDataStack.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 3/29/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import Foundation
import CoreData

//MARK: - Core Data Stack

class CoreDataStack {
    
    // a persistent container that can load cloud-backed and non-cloud stores.
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        // Create a container that can load CloudKit-backed stores
        let container = NSPersistentCloudKitContainer(name: "BetterBudget")
        
        // Enable hitory tracking and remote notifications
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("###\(#function): Failed to load persistent stores: \(error)")
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.transactionAuthor = appTransactionAuthorName
        
        // Pin the viewContext to the current generation token and set it to keep itself up to date with local changes
        // May need to change this since betterbudget dataModel doesn't have any parent-child associations
        container.viewContext.automaticallyMergesChangesFromParent = true
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("###\(#function): Failed to pin viewContext to the current generation token:\(error)")
        }
        
        // Observe Core Data remote change notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(type(of: self).storeRemoteChange(_:)),
            name: .NSPersistentStoreRemoteChange, object: container)
        
        
        return container
    }()
    
    // Track the last history token processed for a store, and write it's value to file
    // The historyQueue reads the token when executing operations, and updates it after processing complete.
    private var lastHistoryToken: NSPersistentHistoryToken? = nil {
        didSet {
            guard let token = lastHistoryToken,
                let data = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else { return }
            
            do {
                try data.write(to: tokenFile)
            } catch {
                print("###\(#function): Failed to write token data. Error = \(error)")
            }
        }
    }
    
    //The file URL for persisting the persistent history token
    private lazy var tokenFile: URL = {
        let url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("BetterBudget", isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("###\(#function): Failed to create persistent container URL. Error = \(error)")
            }
        }
        return url.appendingPathComponent("token.data", isDirectory: false)
    }()
    
    //An operation queue for handling history processing tasks: watching changes, triggering UI updates, etc.
    private lazy var historyQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    //
    
    init() {
        // Load the last token from the token file
        if let tokenData = try? Data(contentsOf: tokenFile) {
            do {
                lastHistoryToken = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSPersistentHistoryToken.self, from: tokenData)
            } catch {
                print("###\(#function): Failed to unarchive NSPersistentHistoryToken. Error = \(error)")
            }
        }
    }
}

//MARK: - Notifications

extension CoreDataStack {
    //Handle remote store change notifications (.NSPersistentStoreRemoteChange)
    @objc
    func storeRemoteChange(_ notification: Notification) {
        print("####\(#function): Merging changes from the other persistent store coordinator.")
        
        //Process persistent history to merge changes from other coordinators.
        historyQueue.addOperation {
            self.processPersistentHistory()
        }
    }
}

// custom notification in this sample
extension Notification.Name {
    static let didFindRelevantTransactions = Notification.Name("didFindRelevantTransactions")
}

//MARK: - Persistent History Processing

extension CoreDataStack {
    //Process persistent history, posting any relevant transactions to the current view
    func processPersistentHistory() {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.performAndWait {
            
            // Fetch history received from outside the app since the last token
            let historyFetchRequest = NSPersistentHistoryTransaction.fetchRequest!
            historyFetchRequest.predicate = NSPredicate(format: "author != %@", appTransactionAuthorName)
            let request = NSPersistentHistoryChangeRequest.fetchHistory(after: lastHistoryToken)
            request.fetchRequest = historyFetchRequest
            
            let result = (try? taskContext.execute(request)) as? NSPersistentHistoryResult
            guard let transactions = result?.result as? [NSPersistentHistoryTransaction],
                !transactions.isEmpty
                else { return }
            
            // Post transactions relevant to the current view
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .didFindRelevantTransactions, object: self, userInfo: ["transactions": transactions])
            }
            
            //Deduplicate the new expenses and new income
            //Maybe revisit this if necessary
            
            lastHistoryToken = transactions.last!.token
            
        }
    }
}









































