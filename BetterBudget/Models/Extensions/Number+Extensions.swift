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
    
    func customNumberPresenter(for type: ExpenseType, preciseDecimal: Int = 2, formatting: Bool = true) -> String {
        
        let absValue = abs(self)

        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2

        if formatting {
            return "\(NSLocale.defaultCurrency) \(absValue.format(formatString: ".\(preciseDecimal)"))"
        } else {
            return "\(NSLocale.defaultCurrency) \(formatter.string(from: NSNumber(value: absValue))!)"
        }
    }
}

/*
extension Double {
    
    func customFormattedAmountString(amount: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current

        if let amountString = formatter.string(from: NSNumber(value: amount)) {
            // check if it has default space like EUR
            let hasSpace = amountString.rangeOfCharacter(from: .whitespaces) != nil

            if let indexOfSymbol = amountString.characters.firstIndex(of: Character(formatter.currencySymbol)) {
                if amountString.startIndex == indexOfSymbol {
                    formatter.paddingPosition = .afterPrefix
                } else {
                    formatter.paddingPosition = .beforeSuffix
                }
            }
            if !hasSpace {
                formatter.formatWidth = amountString.characters.count + 1
                formatter.paddingCharacter = " "
            }
        } else {
            print("Error while making amount string from given amount: \(amount)")
            return nil
        }

        if let finalAmountString = formatter.string(from: NSNumber(value: amount)) {
            return finalAmountString
        } else {
            return nil
        }
    }
 
    // Use customFormattedAmountString() like this:
 
    if let formattedAmount = customFormattedAmountString(amount: 5000000) {
     print(formattedAmount)
    }
    
}
*/
