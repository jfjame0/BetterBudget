//
//  Expense+CoreDateaProperties.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 4/18/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import Foundation
import CoreData

extension Income {
    
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Income> {
        return NSFetchRequest<Income>(entityName: "Income")
    }
    
}

