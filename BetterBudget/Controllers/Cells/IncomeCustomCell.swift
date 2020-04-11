//
//  IncomeCustomCell.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 4/10/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import UIKit

class IncomeCustomCell: UITableViewCell {
    
        //Create the objects
        
        //Needs to have a Title label, aligned left (Expense Title)
        //Needs to have a detail label, aligned right (Amount Detail)
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        //right click into UITableViewCell & figure out how to set the style to Right Detail
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)

                //Design the cell programmatically here.
                
                //Needs to have a Title label, aligned left (Expense Title)
                //Needs to have a detail label, aligned right (Amount Detail) with a detail indicator icon >
                
                
                //Design the objects
                
//                addSubview(titleLabel)
//                titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
//                titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
//                titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
//                titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
//                titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//                titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
