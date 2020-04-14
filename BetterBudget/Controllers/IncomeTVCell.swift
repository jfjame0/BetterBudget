//
//  IncomeTVCell.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 4/13/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import UIKit

class IncomeTVCell: UITableViewCell {

    let incomeTitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        addSubview(incomeTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
