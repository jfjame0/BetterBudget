//
//  Schema.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 3/29/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import CoreData

enum Schema {
    enum Expense: String {
        case title
    }
    enum Amount: Double {
        case amount
    }
    enum DueDate: Any {
        case DueDate
    }
    enum Repeats: String {
        case repeats
    }
    enum Notes: String {
        case notes
    }
    
}
