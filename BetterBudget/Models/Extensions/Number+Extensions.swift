//
//  Number+Extensions.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 4/1/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import Foundation

extension Int {
    func format(formatString: String) -> String {
        return String(format: "%\(formatString)d", self)
    }
}

extension Double {
    func format(formatString: String) -> String {
        return String(format: "%\(formatString)f", self)
    }
    
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
//    func expensePresenter(for type: Expense, preciseDecimal: Int = 2, formatting: Bool = true) -> String {
//
//        var prefix = ""
//
//        let absValue = abs(self)
//
//        let formatter = NumberFormatter()
//        formatter.minimumFractionDigits = 0
//        formatter.maximumFractionDigits = 2
//
//        if formatting {
//            return "\(prefix) \(NSLocale.defaultCurrency) \(absValue.format(formatString: ".\(preciseDecimal)"))"
//        } else {
//            return "\(prefix) \(NSLocale.defaultCurrency) \(formatter.string(from: NSNumber(value: absValue))!)"
//        }
//
//    }
    
}
