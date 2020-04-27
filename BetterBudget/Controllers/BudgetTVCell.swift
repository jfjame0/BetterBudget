//
//  BudgetTVCell.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 4/17/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import UIKit

class BudgetTVCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
//        textLabel?.text = "Expense Title"
//        detailTextLabel?.text = "- $ 150.00"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
