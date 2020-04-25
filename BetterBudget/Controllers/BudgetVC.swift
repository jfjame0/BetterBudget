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
    let date: Date
    let amount: Double
}

class BudgetVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var income: Income?
    var expense: Expense?
    //    var payDates = [Date]()
    var collectedFutureDates = [Date]()
    var collectedIncomeAmounts = [String]()
    var container: NSPersistentContainer!
    var resultController: NSFetchRequestResult!
    fileprivate let cellID = "id"
    
    private lazy var dataProvider: IncomeProvider = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let provider = IncomeProvider(with: appDelegate!.coreDataStack.persistentContainer, fetchedResultsControllerDelegate: self)
        return provider
    }()
    
    //Also import the ExpenseProvider to populate the expenses
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = .init(frame: .zero, style: .grouped)
        //        tableView = .init(frame: .zero, style: .plain)
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        
        var constraints = [NSLayoutConstraint]()
        let guide = view.safeAreaLayoutGuide
        constraints.append(self.tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor))
        constraints.append(self.tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor))
        constraints.append(self.tableView.topAnchor.constraint(equalTo: guide.topAnchor))
        constraints.append(self.tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor))
        
        tableView.register(BudgetTVCell.self, forCellReuseIdentifier: cellID)
        //        tableView.separatorStyle = .none
        
        createFuturePaydays()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return collectedFutureDates.count
    }
    
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
        
        let sortedArray = collectedFutureDates.sorted()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        let dateString = dateFormatter.string(from: sortedArray[section])
        
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
        paycheckAmountLabel.text = "Pay Amount:          $ 1500.00"

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
    
    func createFuturePaydays() {
        
        let calendar = Calendar.current
        let date = Date()
        let fetchRequest = dataProvider.fetchedResultsController.fetchedObjects
        
//        collectedIncomeAmounts and collectedFutureDates need to be combined into a dictionary Key: Value
        
        if let amount = fetchRequest {
            for payday in amount {
                collectedIncomeAmounts.append(String(format: "%.0f", payday.amount))
            }
        }
        
        if let income = fetchRequest {
            for payday in income {
                if payday.repeats == "2 Weeks" {
                    collectedFutureDates.append(payday.payDate ?? date)

                    for _ in collectedFutureDates {
                        repeat {
                            let twoWeeksFromDateSecond = calendar.date(byAdding: .day, value: 14, to: collectedFutureDates.last ?? date)
                            collectedFutureDates.append(twoWeeksFromDateSecond ?? date)
                        } while collectedFutureDates.count < 20
                    }
                }
            }
        }
        print(collectedFutureDates.sorted())
        print(collectedIncomeAmounts)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //numberOfRowsInSection == number of bills due on respective paydate.
        // if else
        return 8
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! BudgetTVCell
        cell.backgroundColor = UIColor.clear
        
        return cell
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
