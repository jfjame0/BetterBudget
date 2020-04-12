//
//  AppDelegate.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 3/22/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var coreDataStack: CoreDataStack = { return CoreDataStack() }()

}

