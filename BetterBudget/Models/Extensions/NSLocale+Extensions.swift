//
//  NSLocale+Extensions.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 4/1/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import Foundation

import Foundation

extension NSLocale {
    static var defaultCurrency: String {
        return UserDefaults.standard.string(forKey: "currencySymbol") ?? ""
    }
}
