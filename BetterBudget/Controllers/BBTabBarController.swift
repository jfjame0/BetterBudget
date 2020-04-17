//
//  BBTabBarController.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 4/5/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import UIKit

class BBTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.green
        
        let appearance = UITabBarAppearance()
        appearance.selectionIndicatorTintColor = UIColor.systemGreen
        
        setupTabBar()
    }
    
    func setupTabBar() {
        
        let textAppearance = [NSAttributedString.Key.foregroundColor: UIColor.systemGreen]
//        navigationController?.navigationBar.titleTextAttributes = textAppearance
        
        let firstViewController = UINavigationController(rootViewController: IncomeTVC())
        firstViewController.tabBarItem = UITabBarItem(title: "Income", image: UIImage(systemName: "dollarsign.circle.fill"), tag: 0)
        firstViewController.navigationBar.tintColor = UIColor.systemGreen
        firstViewController.navigationBar.titleTextAttributes = textAppearance
        
        let secondViewController = UINavigationController(rootViewController: BudgetVC())
        secondViewController.tabBarItem = UITabBarItem(title: "My Budget", image: UIImage(systemName: "house.fill"), tag: 1)
        secondViewController.navigationBar.tintColor = UIColor.systemGreen
        secondViewController.navigationBar.titleTextAttributes = textAppearance
        
        let thirdViewController = UINavigationController(rootViewController: ExpensesTVC())
        thirdViewController.tabBarItem = UITabBarItem(title: "Expenses", image: UIImage(systemName: "tray.and.arrow.down.fill"), tag: 2)
        thirdViewController.navigationBar.tintColor = UIColor.systemGreen
        thirdViewController.navigationBar.titleTextAttributes = textAppearance
        
        let tabBarList = [firstViewController, secondViewController, thirdViewController]
        
        viewControllers = tabBarList
    }
}
