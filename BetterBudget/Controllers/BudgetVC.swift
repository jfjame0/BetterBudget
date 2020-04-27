//
//  BudgetVC.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 4/11/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//
import UIKit
import CoreData
import CloudKit

struct PayDay {
    let title: String
    let date: Date
    let amount: Double
}

struct Bill {
    let title: String
    let date: Date
    let amount: Double
}

class BudgetVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var income: Income?
    var expense: Expense?
    
    var paydayArray:[PayDay] = []
    var billArray:[Bill] = []
    
    var container: NSPersistentContainer!
    var resultController: NSFetchRequestResult!
    fileprivate let cellID = "id"
    
    private lazy var incDataProvider: IncomeProvider = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let provider = IncomeProvider(with: appDelegate!.coreDataStack.persistentContainer, fetchedResultsControllerDelegate: self)
        return provider
    }()
    
    private lazy var expDataProvider: ExpenseProvider = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let provider = ExpenseProvider(with: appDelegate!.coreDataStack.persistentContainer,
                                       fetchedResultsControllerDelegate: self)
        return provider
    }()
    
    //TODO: - Also import the ExpenseProvider to populate the expenses
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = .init(frame: .zero, style: .grouped)
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update Beginning Account Balance", style: .plain, target: self, action: #selector(updateAccountBalance))
        
        tableView.register(BudgetTVCell.self, forCellReuseIdentifier: cellID)
        //        tableView.separatorStyle = .none
        
        createFuturePaydays()
        populateExpenses()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return paydayArray.count//collectedFutureDates.count
    }
    
    //TODO: - Create Updated Account Balance Label + TextField
    
    class PayDayHeaderLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            
            return CGSize(width: originalContentSize.width + 16, height: height)
        }
    }
    
    class PaycheckAmountLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            
            return CGSize(width: originalContentSize.width + 16, height: height)
        }
    }
    
    class AccountBalanceLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            
            return CGSize(width: originalContentSize.width + 16, height: height)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        let payDayDescr = paydayArray[section]
        let dateString = dateFormatter.string(from: payDayDescr.date)
        let amountString = String(format: "%.2f", payDayDescr.amount)
        let titleString = payDayDescr.title
        
        
        let payDateLabel = PayDayHeaderLabel()
        payDateLabel.backgroundColor = UIColor.orange.withAlphaComponent(0.2)
        payDateLabel.text = "Payday:   \(dateString)"
        payDateLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        payDateLabel.textAlignment = .center
        payDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let paycheckAmountLabel = PaycheckAmountLabel()
        paycheckAmountLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        paycheckAmountLabel.textAlignment = .center
        paycheckAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        paycheckAmountLabel.text = "\(titleString):         + $ \(amountString)"
        
        let accountBalanceLabel = AccountBalanceLabel()
        accountBalanceLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        accountBalanceLabel.text = "Account Balance:          $ 2350.00"
        accountBalanceLabel.textAlignment = .center
        accountBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        containerView.addSubview(payDateLabel)
        containerView.addSubview(paycheckAmountLabel)
        containerView.addSubview(accountBalanceLabel)
        
        NSLayoutConstraint.activate([
            payDateLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            payDateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            paycheckAmountLabel.topAnchor.constraint(equalTo: payDateLabel.bottomAnchor, constant: 8),
            paycheckAmountLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12),
            accountBalanceLabel.topAnchor.constraint(equalTo: paycheckAmountLabel.bottomAnchor, constant: 8),
            accountBalanceLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12),
            accountBalanceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
        ])
        
        return containerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130
    }
    
    class AccountSurplusLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.masksToBounds = true
            
            return CGSize(width: originalContentSize.width + 16, height: height)
        }
    }
    
    class AccountSurplusAmountLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.masksToBounds = true
            
            return CGSize(width: originalContentSize.width + 16, height: height)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let accountSurplusLabel = AccountSurplusLabel()
        accountSurplusLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        accountSurplusLabel.text = "Account Surplus:"
        accountSurplusLabel.textAlignment = .center
        accountSurplusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let accountSurplusAmountLabel = AccountSurplusAmountLabel()
        accountSurplusAmountLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        accountSurplusAmountLabel.text = "$ 650.00"
        accountSurplusAmountLabel.textAlignment = .center
        accountSurplusAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.green.withAlphaComponent(0.2)
        containerView.addSubview(accountSurplusLabel)
        containerView.addSubview(accountSurplusAmountLabel)
        
        NSLayoutConstraint.activate([
            accountSurplusLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            accountSurplusLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12),
            accountSurplusLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            accountSurplusAmountLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            accountSurplusAmountLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12),
            accountSurplusAmountLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        return containerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //numberOfRowsInSection == number of bills due on respective paydate.
        // if else
        return 8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! BudgetTVCell
        cell.backgroundColor = UIColor.clear
        
        //If the bill dueDate is before the payday date && after the previous paydate, then the cell textLabel should show the bill, else, it doesn't.
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        let billDueDates = billArray[indexPath.row]
//        let payDayDescr = paydayArray[indexPath.row]
        let dateString = dateFormatter.string(from: billDueDates.date)
        let amountString = String(format: "%.2f", billDueDates.amount)
        let titleString = billDueDates.title
        
//        if billDueDates.date < payDayDescr.date {
//
//            cell.textLabel?.text = "\(titleString) / \(dateString)"
//
//            cell.detailTextLabel?.text = "\(amountString)"
//        }
        cell.textLabel?.text = "\(titleString) / \(dateString)"
        
        cell.detailTextLabel?.text = "- $ \(amountString)"
        
//        print(billArray[indexPath.row])
        
        return cell
    }
    

    
    func createFuturePaydays() {
        
        let calendar = Calendar.current
        let fetchRequest = incDataProvider.fetchedResultsController.fetchedObjects
        
        if let income = fetchRequest {
            for payday in income {
                
                if payday.repeats == "None" {
                    let title = payday.title ?? ""
                    let date = payday.payDate ?? Date()
                    let payDayDescr = PayDay(title: title, date: date, amount: payday.amount)
                    
                    paydayArray.append(payDayDescr)
                }
                
                if payday.repeats == "Weekly" {
                    let title = payday.title ?? ""
                    let date = payday.payDate ?? Date()
                    let payDayDescr = PayDay(title: title, date: date, amount: payday.amount)
                    
                    paydayArray.append(payDayDescr)
                    
                    var currentDate = date
                    var i = 0
                    repeat {
                        if let futureDate = calendar.date(byAdding: .day, value: 7, to: currentDate) {
                            let payDayDescr = PayDay(title: title, date: futureDate, amount: payday.amount)
                            paydayArray.append(payDayDescr)
                            currentDate = futureDate
                        }
                        i += 1
                    } while i < 20
                }
                
                if payday.repeats == "2 Weeks" {
                    let title = payday.title ?? ""
                    let date = payday.payDate ?? Date()
                    let payDayDescr = PayDay(title: title, date: date, amount: payday.amount)
                    
                    paydayArray.append(payDayDescr)
                    
                    var currentDate = date
                    var i = 0
                    repeat {
                        if let futureDate = calendar.date(byAdding: .day, value: 14, to: currentDate) {
                            let payDayDescr = PayDay(title: title, date: futureDate, amount: payday.amount)
                            paydayArray.append(payDayDescr)
                            currentDate = futureDate
                        }
                        i += 1
                    } while i < 20
                }
                
                if payday.repeats == "Monthly" {
                    let title = payday.title ?? ""
                    let date = payday.payDate ?? Date()
                    let payDayDescr = PayDay(title: title, date: date, amount: payday.amount)
                    
                    paydayArray.append(payDayDescr)
                    
                    var currentDate = date
                    var i = 0
                    repeat {
                        if let futureDate = calendar.date(byAdding: .month, value: 1, to: currentDate) {
                            let payDayDescr = PayDay(title: title, date: futureDate, amount: payday.amount)
                            paydayArray.append(payDayDescr)
                            currentDate = futureDate
                        }
                        i += 1
                    } while i < 20
                }
                
                if payday.repeats == "2 Months" {
                    let title = payday.title ?? ""
                    let date = payday.payDate ?? Date()
                    let payDayDescr = PayDay(title: title, date: date, amount: payday.amount)
                    
                    paydayArray.append(payDayDescr)
                    
                    var currentDate = date
                    var i = 0
                    repeat {
                        if let futureDate = calendar.date(byAdding: .month, value: 2, to: currentDate) {
                            let payDayDescr = PayDay(title: title, date: futureDate, amount: payday.amount)
                            paydayArray.append(payDayDescr)
                            currentDate = futureDate
                        }
                        i += 1
                    } while i < 20
                }
                
                if payday.repeats == "6 Months" {
                    let title = payday.title ?? ""
                    let date = payday.payDate ?? Date()
                    let payDayDescr = PayDay(title: title, date: date, amount: payday.amount)
                    
                    paydayArray.append(payDayDescr)
                    
                    var currentDate = date
                    var i = 0
                    repeat {
                        if let futureDate = calendar.date(byAdding: .month, value: 6, to: currentDate) {
                            let payDayDescr = PayDay(title: title, date: futureDate, amount: payday.amount)
                            paydayArray.append(payDayDescr)
                            currentDate = futureDate
                        }
                        i += 1
                    } while i < 20
                }
                
                if payday.repeats == "Yearly" {
                    let title = payday.title ?? ""
                    let date = payday.payDate ?? Date()
                    let payDayDescr = PayDay(title: title, date: date, amount: payday.amount)
                    
                    paydayArray.append(payDayDescr)
                    
                    var currentDate = date
                    var i = 0
                    repeat {
                        if let futureDate = calendar.date(byAdding: .year, value: 1, to: currentDate) {
                            let payDayDescr = PayDay(title: title, date: futureDate, amount: payday.amount)
                            paydayArray.append(payDayDescr)
                            currentDate = futureDate
                        }
                        i += 1
                    } while i < 20
                }
                
            }
        }
        
        paydayArray = paydayArray.sorted {
            return $0.date < $1.date
        }
    }
    
    func populateExpenses() {
        
        let calendar = Calendar.current
        let fetchRequest = expDataProvider.fetchedResultsController.fetchedObjects
        
        if let expenses = fetchRequest {
            
            for bill in expenses {
                
                //If the bill dueDate
                
                if bill.repeats == "None" {
                    let title = bill.title ?? ""
                    let date = bill.dueDate ?? Date()
                    let billDescr = Bill(title: title, date: date, amount: bill.amount)
                    
                    billArray.append(billDescr)
                }
                
                if bill.repeats == "Weekly" {
                    let title = bill.title ?? ""
                    let date = bill.dueDate ?? Date()
                    let billDescr = Bill(title: title, date: date, amount: bill.amount)
                    
                    billArray.append(billDescr)
                    
                    var currentDate = date
                    var i = 0
                    repeat {
                        if let futureDate = calendar.date(byAdding: .day, value: 7, to: currentDate) {
                            let billDescr = Bill(title: title, date: futureDate, amount: bill.amount)
                            billArray.append(billDescr)
                            currentDate = futureDate
                        }
                        i += 1
                    } while i < 20
                }
                
                if bill.repeats == "2 Weeks" {
                    let title = bill.title ?? ""
                    let date = bill.dueDate ?? Date()
                    let billDescr = Bill(title: title, date: date, amount: bill.amount)
                    
                    billArray.append(billDescr)
                    
                    var currentDate = date
                    var i = 0
                    repeat {
                        if let futureDate = calendar.date(byAdding: .day, value: 14, to: currentDate) {
                            let billDescr = Bill(title: title, date: futureDate, amount: bill.amount)
                            billArray.append(billDescr)
                            currentDate = futureDate
                        }
                        i += 1
                    } while i < 20
                }
                
                if bill.repeats == "Monthly" {
                    let title = bill.title ?? ""
                    let date = bill.dueDate ?? Date()
                    let billDescr = Bill(title: title, date: date, amount: bill.amount)
                    
                    billArray.append(billDescr)
                    
                    var currentDate = date
                    var i = 0
                    repeat {
                        if let futureDate = calendar.date(byAdding: .month, value: 1, to: currentDate) {
                            let billDescr = Bill(title: title, date: futureDate, amount: bill.amount)
                            billArray.append(billDescr)
                            currentDate = futureDate
                        }
                        i += 1
                    } while i < 20
                }
                
                if bill.repeats == "2 Months" {
                    let title = bill.title ?? ""
                    let date = bill.dueDate ?? Date()
                    let billDescr = Bill(title: title, date: date, amount: bill.amount)
                    
                    billArray.append(billDescr)
                    
                    var currentDate = date
                    var i = 0
                    repeat {
                        if let futureDate = calendar.date(byAdding: .month, value: 2, to: currentDate) {
                            let billDescr = Bill(title: title, date: futureDate, amount: bill.amount)
                            billArray.append(billDescr)
                            currentDate = futureDate
                        }
                        i += 1
                    } while i < 20
                }
                
                if bill.repeats == "6 Months" {
                    let title = bill.title ?? ""
                    let date = bill.dueDate ?? Date()
                    let billDescr = Bill(title: title, date: date, amount: bill.amount)
                    
                    billArray.append(billDescr)
                    
                    var currentDate = date
                    var i = 0
                    repeat {
                        if let futureDate = calendar.date(byAdding: .month, value: 6, to: currentDate) {
                            let billDescr = Bill(title: title, date: futureDate, amount: bill.amount)
                            billArray.append(billDescr)
                            currentDate = futureDate
                        }
                        i += 1
                    } while i < 20
                }
                
                if bill.repeats == "Yearly" {
                    let title = bill.title ?? ""
                    let date = bill.dueDate ?? Date()
                    let billDescr = Bill(title: title, date: date, amount: bill.amount)
                    
                    billArray.append(billDescr)
                    
                    var currentDate = date
                    var i = 0
                    repeat {
                        if let futureDate = calendar.date(byAdding: .year, value: 1, to: currentDate) {
                            let billDescr = Bill(title: title, date: futureDate, amount: bill.amount)
                            billArray.append(billDescr)
                            currentDate = futureDate
                        }
                        i += 1
                    } while i < 20
                }
                
            }
            
        }
        billArray = billArray.sorted {
            return $0.date < $1.date
        }
        
        print(billArray)
        
    }
    
    func calculateAccountBalance() {
        
        
        
    }
    
    
    
}

extension BudgetVC {
    
    @objc
    func updateAccountBalance(_ sender: UIBarButtonItem) {
        
        
    }
    
}

import SwiftUI

struct MainPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) -> UIViewController {
            return BudgetVC()
        }
        
        func updateUIViewController(_ uiViewController: MainPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) {
        }
    }
}
