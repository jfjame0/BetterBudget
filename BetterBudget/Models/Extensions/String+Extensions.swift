//
//  String+Extensions.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 4/1/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import Foundation

extension String {
    
    func getDoubleFromLocal() -> Double {
        var value = 0.0
        let numberFormatter = NumberFormatter()
        let decimalFiltered = self.replacingOccurrences(of: "٫|,", with: ".", options: .regularExpression)
        numberFormatter.locale = Locale(identifier: "EN")
        if let amountValue = numberFormatter.number(from: decimalFiltered) {
            value = amountValue.doubleValue
        }
        return value
    }
}

extension String {
    
    // Inner comparison utility to handle same versions with different length(ex: "1.0.0" & "1.0")
    private func compare(toVersion targetVersion: String) -> ComparisonResult {
        
        let versionDelimter = "."
        var result: ComparisonResult = .orderedSame
        var versionComponents = components(separatedBy: versionDelimter)
        var targetComponents = targetVersion.components(separatedBy: versionDelimter)
        let spareCount = versionComponents.count - targetComponents.count
        
        if spareCount == 0 {
            result = compare(targetVersion, options: .numeric)
        } else {
            let spareZeros = repeatElement("0", count: abs(spareCount))
            if spareCount > 0  {
                targetComponents.append(contentsOf: spareZeros)
            } else {
                versionComponents.append(contentsOf: spareZeros)
            }
            result = versionComponents.joined(separator: versionDelimter).compare(targetComponents.joined(separator: versionDelimter), options: .numeric)
        }
        return result
        
    }
    
    public func isVersion(equalTo targetVersion: String) -> Bool {
        return compare(toVersion: targetVersion) == .orderedSame
    }
    
    public func isVersion(greaterThan targetVersion: String) -> Bool {
        return compare(toVersion: targetVersion) == .orderedDescending
    }

    public func isVersion(greaterThanOrEqualTo targetVersion: String) -> Bool {
        return compare(toVersion: targetVersion) != .orderedAscending
    }

    public func isVersion(lessThan targetVersion: String) -> Bool {
        return compare(toVersion: targetVersion) == .orderedAscending
    }

    public func isVersion(lessThanOrEqualTo targetVersion: String) -> Bool {
        return compare(toVersion: targetVersion) != .orderedDescending
    }
    
}
