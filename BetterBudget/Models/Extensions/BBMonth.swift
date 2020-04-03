//
//  BBMonth.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 4/1/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import Foundation

struct BBMonth {
    let year: Int
    let shortYear: Int
    let month: Int
    let title: String
    let shortTitle: String
    let currentYear: Bool
    
    var titleWithYear: String {
        return "\(title) \(year)"
    }
    
    var shortTitleWithYear: String {
        return "\(shortTitle) \(shortYear)"
    }
    
    var titleWithCurrentYear: String {
        return currentYear ? title : titleWithYear
    }
    
    var shortTitleWithCurrentYear: String {
        return currentYear ? shortTitle :shortTitleWithYear
    }
}
