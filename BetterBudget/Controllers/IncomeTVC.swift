//
//  IncomeTVC.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 4/5/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class IncomeTVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    weak var incomeTVC: IncomeTVC?
    weak var incomeDetailTVC: IncomeDetailTVC?
    
//    var gradient : CAGradientLayer?
//    let gradientView : UIView = {
//        let view = UIView()
//        return view
//    }()
    
    private lazy var dataProvider: IncomeProvider = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let provider = IncomeProvider(with: appDelegate!.coreDataStack.persistentContainer, fetchedResultsControllerDelegate: self)
        return provider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.title = "Income"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //addTapped() is at the bottom of this view controller
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor.systemGreen
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.systemGreen
        navigationItem.leftBarButtonItem?.tintColor = UIColor.systemGreen

        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false

        
        tableView.register(IncomeCustomCell.self, forCellReuseIdentifier: "IncomeListCell")

        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).didFindRelevantTransactions(_:)),
            name: .didFindRelevantTransactions, object: nil)
        
//        setupClearNavBar()
//        setupGradient()
        tableView.reloadData()
        didUpdateIncome(nil)
 
    }

    /*
    func setupGradient() {
        // Calculates the size of NavBar (Either large or normal)
//        guard let height = navigationController?.navigationBar.frame.height else { return }
        let height : CGFloat = 90
        let color = UIColor.black.withAlphaComponent(0.7).cgColor
        let clear = UIColor.black.withAlphaComponent(0.0).cgColor
        gradient = setupGradient(height: height, topColor: color,bottomColor: clear)
        view.addSubview(gradientView)
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])
        gradientView.layer.insertSublayer(gradient!, at: 0)
    }
    */
    
    //TODO: - RefreshControl needs to work. Currently, it does not.
    func refreshControlValueChanged(_ sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
        print("refreshControlValueChanged")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Set Editing
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if !editing {
            tableView.reloadData()
            didUpdateIncome(nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let incomeDetailTVC = IncomeDetailTVC()
        if let indexPath = tableView.indexPathForSelectedRow {
            let income = dataProvider.fetchedResultsController.object(at: indexPath)
            incomeDetailTVC.income = income
        }
        present(incomeDetailTVC, animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "incomeDetailSegue",
//            let incomeDetailTVC = segue.destination as? IncomeDetailTVC else {
//                return
//        }
//
//        navigationItem.leftItemsSupplementBackButton = true
//
//        if let indexPath = tableView.indexPathForSelectedRow {
//            let income = dataProvider.fetchedResultsController.object(at: indexPath)
//            incomeDetailTVC.income = income
//        }
//    }
    
    
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

// MARK: - Table view DataSource and Delegate

extension IncomeTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeListCell", for: indexPath)
        
        let income = dataProvider.fetchedResultsController.object(at: indexPath)

        cell.textLabel?.text = income.title
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currency
        formatter.locale = .current
        // MARK: - Need to add space between the $ & amount - Refer to extension in Number+Extensions.swift
        // Needs to look like this: $ 55 and not $55
        cell.detailTextLabel?.text = String("\(formatter.string(from: NSNumber(value: income.amount))!)")
        //        cell.detailTextLabel?.text = expense.amount.customNumberPresenter(for: .expense, formatting: true)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let income = dataProvider.fetchedResultsController.object(at: indexPath)
        dataProvider.delete(income: income) {
            self.didUpdateIncome(nil)
        }
    }
}

//MARK: - Handling didFindRelevantTransactions

extension IncomeTVC {
    
    @objc
    func didFindRelevantTransactions(_ notification: Notification) {
        guard let relevantTransactions = notification.userInfo?["transactions"] as? [NSPersistentHistoryTransaction] else { preconditionFailure() }
        
        guard let incomeDetailTVC = incomeDetailTVC, let income = incomeDetailTVC.income else {
            update(with: relevantTransactions, select: nil)
            return
        }
        
        // Check if the current selected post is deleted or updated.
        // If not, and the user isn't editing it, merge the changes silently; otherwise, alert the user and go back to the main view
        var isSelectedIncomeChanged = false
        var changeType: NSPersistentHistoryChangeType?
        
        loop0: for transaction in relevantTransactions {
            for change in transaction.changes! where change.changedObjectID == income.objectID {
                if change.changeType == .delete || change.changeType == .update {
                    isSelectedIncomeChanged = true
                    changeType = change.changeType
                    break loop0
                }
            }
        }
        
        if !isSelectedIncomeChanged ||
            (!incomeDetailTVC.isEditing && incomeDetailTVC.presentedViewController == nil) {
            if let changeType = changeType, changeType == .delete {
                update(with: relevantTransactions, select: nil)
            } else {
                update(with: relevantTransactions, select: income)
            }
            return
        }
        
        // The selected expense was changed and the user isn't editing it.
        // Show an alert, and go back to the main view and reload everything after the user confirms.
        let alert = UIAlertController(title: "Core Data CloudKit Alert", message: "This expense has been deleted by a peer!", preferredStyle: .alert)
        
        // potToRootViewController does nothing when the splitViewController is not collapsed.
        alert.addAction(UIAlertAction(title: "Reload the main view", style: .default) {_ in
            
            if incomeDetailTVC.presentedViewController != nil {
                incomeDetailTVC.dismiss(animated: true) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
            self.resetAndReload(select: income)
        })
        
        // Present the alert controller.
        var presentingViewController: UIViewController = incomeDetailTVC
        if incomeDetailTVC.presentedViewController != nil {
            presentingViewController = incomeDetailTVC.presentedViewController!
        }
        presentingViewController.present(alert, animated: true)
    }
    
    // Reset and reload if the transaction count is high. When there are only a few transactions, merge the changes one by one.
    // Adjust the number of transactions based on performance.
    private func update(with transactions: [NSPersistentHistoryTransaction], select income: Income?) {
        if transactions.count > 20 {
            print("###\(#function): Relevant transactions: \(transactions.count), reset and reload.")
            resetAndReload(select: income)
            return
        }
        
        transactions.forEach { transaction in
            guard let userInfo = transaction.objectIDNotification().userInfo else { return }
            let viewContext = dataProvider.persistentContainer.viewContext
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: userInfo, into: [viewContext])
        }
        didUpdateIncome(income)
    }
    
    private func resetAndReload(select income: Income?) {
        dataProvider.persistentContainer.viewContext.reset()
        do {
            try self.dataProvider.fetchedResultsController.performFetch()
        } catch {
            fatalError("###\(#function): Failed to performFetch: \(error)")
        }
        //May need to adjust the reloadSections because the TVC is managing the sections in numberOfSections
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        didUpdateIncome(income)
    }
}

extension IncomeTVC: IncomeInteractionDelegate {
    func didUpdateIncome(_ income: Income?, shouldReloadRow: Bool = false) {
        let rowCount = dataProvider.fetchedResultsController.fetchedObjects?.count ?? 0
        
        navigationItem.leftBarButtonItem?.isEnabled = (rowCount > 0) ? true : false
        
        // Get the indexPath for the expense. Use the currently selected indexPath if any, or the first row otherwise.
        // indexPath will remain nil if the tableView has no data.
        var indexPath: IndexPath?
        if let income = income {
            indexPath = dataProvider.fetchedResultsController.indexPath(forObject: income)
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
        guard let incomeDetailTVC = incomeDetailTVC else { return }
        
        if let indexPath = indexPath {
            incomeDetailTVC.income = dataProvider.fetchedResultsController.object(at: indexPath)
        } else {
            incomeDetailTVC.income = income
        }
        incomeDetailTVC.populateUI()
    }
    
    func willShowIncomeDetailTVC(_ controller: IncomeDetailTVC) {
        if controller.delegate == nil {
            incomeDetailTVC = controller
            controller.delegate = self
        }
        
        if let income = controller.income {
            if tableView.indexPathForSelectedRow == nil {
                if let selectedRow = dataProvider.fetchedResultsController.indexPath(forObject: income) {
                    tableView.selectRow(at: selectedRow, animated: true, scrollPosition: .none)
                }
            }
        } else {
            if tableView.numberOfRows(inSection: 0) > 0 {
                didUpdateIncome(nil)
            }
        }
    }
}

//MARK: - Action Handlers

extension IncomeTVC {
    
    @objc
    func addTapped(_ sender: UIBarButtonItem) {
        dataProvider.addIncome(in: dataProvider.persistentContainer.viewContext) { income in
            self.didUpdateIncome(income)
            self.resetAndReload(select: income)
        }
    }
}
