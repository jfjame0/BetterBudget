//
//  ExpensesTVC.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 3/22/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class ExpensesTVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    weak var expensesTVC: ExpensesTVC?
    weak var expenseDetailTVC: ExpenseDetailTVC?
    fileprivate let cellID = "RightDetailTVCell"
    
    private lazy var dataProvider: ExpenseProvider = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let provider = ExpenseProvider(with: appDelegate!.coreDataStack.persistentContainer,
                                       fetchedResultsControllerDelegate: self)
        return provider
    }()
    
    //MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.title = "Expenses"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        tableView.register(RightDetailTVCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ExpensesTVC.refreshControlValueChanged(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        // Observe .didFinishRelevantTransactions to update the UI if needed.
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).didFindRelevantTransactions(_:)),
            name: .didFindRelevantTransactions, object: nil)
        
        tableView.reloadData()
        didUpdateExpense(nil)
        
    }
    
    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        tableView.reloadData()
//        self.tableView.refreshControl?.endRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.endRefreshing()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Set Editing
    //setEditing clears the current selection which expenseDetailTVC relies on.
    // Don't bother to reserve the selection, just select the first item, if any.
    // Meanwhile, editButtonItem will break the tableView selection after deletions. Reloading tableView after works around the issue.
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if !editing {
            tableView.reloadData()
            didUpdateExpense(nil)
        }
    }
    
    //MARK: - DidSelectRowAt - showExpenseDetailTVC
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let expenseDetail = ExpenseDetailTVC()
        if let indexPath = tableView.indexPathForSelectedRow {
            let expense = dataProvider.fetchedResultsController.object(at: indexPath)
            expenseDetail.expense = expense
        }
        navigationController?.pushViewController(expenseDetail, animated: true)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

// MARK: - Table view DataSource and Delegate

extension ExpensesTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let expense = dataProvider.fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = expense.title
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currency
        formatter.locale = .current
        // MARK: - Need to add space between the $ & amount - Refer to extension in Number+Extensions.swift
        // Needs to look like this: $ 55 and not $55
        cell.detailTextLabel?.text = String("\(formatter.string(from: NSNumber(value: expense.amount))!)")
        //        cell.detailTextLabel?.text = expense.amount.customNumberPresenter(for: .expense, formatting: true)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let expense = dataProvider.fetchedResultsController.object(at: indexPath)
        dataProvider.delete(expense: expense) {
            self.didUpdateExpense(nil)
        }
    }
}

//MARK: - Handling didFindRelevantTransactions

extension ExpensesTVC {
    
    @objc
    func didFindRelevantTransactions(_ notification: Notification) {
        guard let relevantTransactions = notification.userInfo?["transactions"] as? [NSPersistentHistoryTransaction] else { preconditionFailure() }
        
        guard let expenseDetailTVC = expenseDetailTVC, let expense = expenseDetailTVC.expense else {
            update(with: relevantTransactions, select: nil)
            return
        }
        
        // Check if the current selected post is deleted or updated.
        // If not, and the user isn't editing it, merge the changes silently; otherwise, alert the user and go back to the main view
        var isSelectedExpenseChanged = false
        var changeType: NSPersistentHistoryChangeType?
        
        loop0: for transaction in relevantTransactions {
            for change in transaction.changes! where change.changedObjectID == expense.objectID {
                if change.changeType == .delete || change.changeType == .update {
                    isSelectedExpenseChanged = true
                    changeType = change.changeType
                    break loop0
                }
            }
        }
        
        if !isSelectedExpenseChanged ||
            (!expenseDetailTVC.isEditing && expenseDetailTVC.presentedViewController == nil) {
            if let changeType = changeType, changeType == .delete {
                update(with: relevantTransactions, select: nil)
            } else {
                update(with: relevantTransactions, select: expense)
            }
            return
        }
        
        // The selected expense was changed and the user isn't editing it.
        // Show an alert, and go back to the main view and reload everything after the user confirms.
        let alert = UIAlertController(title: "Core Data CloudKit Alert", message: "This expense has been deleted by a peer!", preferredStyle: .alert)
        
        // potToRootViewController does nothing when the splitViewController is not collapsed.
        alert.addAction(UIAlertAction(title: "Reload the main view", style: .default) {_ in
            
            if expenseDetailTVC.presentedViewController != nil {
                expenseDetailTVC.dismiss(animated: true) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
            self.resetAndReload(select: expense)
        })
        
        // Present the alert controller.
        var presentingViewController: UIViewController = expenseDetailTVC
        if expenseDetailTVC.presentedViewController != nil {
            presentingViewController = expenseDetailTVC.presentedViewController!
        }
        presentingViewController.present(alert, animated: true)
    }
    
    // Reset and reload if the transaction count is high. When there are only a few transactions, merge the changes one by one.
    // Adjust the number of transactions based on performance.
    private func update(with transactions: [NSPersistentHistoryTransaction], select expense: Expense?) {
        if transactions.count > 20 {
            print("###\(#function): Relevant transactions: \(transactions.count), reset and reload.")
            resetAndReload(select: expense)
            return
        }
        
        transactions.forEach { transaction in
            guard let userInfo = transaction.objectIDNotification().userInfo else { return }
            let viewContext = dataProvider.persistentContainer.viewContext
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: userInfo, into: [viewContext])
        }
        didUpdateExpense(expense)
    }
    
    private func resetAndReload(select expense: Expense?) {
        dataProvider.persistentContainer.viewContext.reset()
        do {
            try self.dataProvider.fetchedResultsController.performFetch()
        } catch {
            fatalError("###\(#function): Failed to performFetch: \(error)")
        }
        //May need to adjust the reloadSections because the TVC is managing the sections in numberOfSections
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        didUpdateExpense(expense)
    }
}

extension ExpensesTVC: ExpenseInteractionDelegate {
    func didUpdateExpense(_ expense: Expense?, shouldReloadRow: Bool = false) {
        let rowCount = dataProvider.fetchedResultsController.fetchedObjects?.count ?? 0
        
        navigationItem.leftBarButtonItem?.isEnabled = (rowCount > 0) ? true : false
        
        // Get the indexPath for the expense. Use the currently selected indexPath if any, or the first row otherwise.
        // indexPath will remain nil if the tableView has no data.
        var indexPath: IndexPath?
        if let expense = expense {
            indexPath = dataProvider.fetchedResultsController.indexPath(forObject: expense)
        } else {
            indexPath = tableView.indexPathForSelectedRow
            if indexPath == nil && tableView.numberOfRows(inSection: 0) > 0 {
                indexPath = IndexPath(row: 0, section: 0)
            }
        }
        
        //Update the ExpenseDetailTVC if needed
        //shouldReloadRow is true when the change was made in the ExpenseDetailTVC, so no need to update.
        guard !shouldReloadRow else { return }
        
        //Reload the ExpenseDtailTVC if needed.
        guard let expenseDetailTVC = expenseDetailTVC else { return }
        
        if let indexPath = indexPath {
            expenseDetailTVC.expense = dataProvider.fetchedResultsController.object(at: indexPath)
        } else {
            expenseDetailTVC.expense = expense
        }
        expenseDetailTVC.populateUI()
    }
    
    func willShowExpenseDetailTVC(_ controller: ExpenseDetailTVC) {
        if controller.delegate == nil {
            expenseDetailTVC = controller
            controller.delegate = self
        }
        
        if let expense = controller.expense {
            if tableView.indexPathForSelectedRow == nil {
                if let selectedRow = dataProvider.fetchedResultsController.indexPath(forObject: expense) {
                    tableView.selectRow(at: selectedRow, animated: true, scrollPosition: .none)
                }
            }
        } else {
            if tableView.numberOfRows(inSection: 0) > 0 {
                didUpdateExpense(nil)
            }
        }
    }
}

//MARK: - Action Handlers

extension ExpensesTVC {
    
    @objc
    func addTapped(_ sender: UIBarButtonItem) {
        dataProvider.addExpense(in: dataProvider.persistentContainer.viewContext) { expense in
            self.didUpdateExpense(expense)
            self.resetAndReload(select: expense)
        }
    }
}
