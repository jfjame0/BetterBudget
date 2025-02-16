//
//  IncomeInteractionDelegate.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 3/29/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import Foundation

protocol IncomeInteractionDelegate: class {
    
    //When the ExpenseDetailTVC has finished an edit, it calls didUpdateExpense for the delgate (ExpensesTVC) to update the UI.
    //When deleting an expense, pass nil for expense
    
    func didUpdateIncome(_ expense: Income?, shouldReloadRow: Bool)
    
    
    //Call this method so that the ExpensesTVC has a chance to build up the connection.
    func willShowIncomeDetailTVC(_ controller: IncomeDetailTVC)
}
