//
//  BudgetVC.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 4/11/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import UIKit

class BudgetVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    fileprivate let headerID = "headerID"
    fileprivate let padding: CGFloat = 10
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        //        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .clear
        collectionView.register(BudgetCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupCollectionView()
        
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
}

extension BudgetVC {
    //Header in cell
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath)
        return header
    }
    
    //Header in cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 54
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor.green.withAlphaComponent(0.4)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - padding, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

class BudgetCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let payDateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pay Date"
        label.textAlignment = .center
        return label
    }()
    
    let payAmountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pay Amount:"
        label.textAlignment = .left
        //        label.textColor = UIColor.gray
        //        label.font = label.font?.withSize(17)
        return label
    }()
    
    let payAmountMoneyLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$ 1500.00"
        label.textAlignment = .right
        //        label.textColor = UIColor.gray
        //        label.font = label.font?.withSize(17)
        return label
    }()
    
    let accountBalanceLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Account Balance"
        label.textAlignment = .left
        return label
    }()
    
    let totalExpensesLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total Expenses:"
        label.textAlignment = .left
        return label
    }()
    
    let surplusLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Surplus:"
        label.textAlignment = .left
        return label
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    func setupViews() {
        addSubview(payDateLabel)
        addSubview(payAmountLabel)
        addSubview(payAmountMoneyLabel)
        addSubview(accountBalanceLabel)
        addSubview(totalExpensesLabel)
        addSubview(surplusLabel)
        
        //Horizontal constraints: the v0 represetnts the space in the middle
        addConstraintsWithFormat("H:|-10-[v0]-10-|", views: payDateLabel)
        addConstraintsWithFormat("H:|-10-[v0(140)]-10-|", views: payAmountLabel)
        addConstraintsWithFormat("H:|-10-[v0(140)]-10-|", views: accountBalanceLabel)
        addConstraintsWithFormat("H:|-10-[v0(140)]-10-|", views: totalExpensesLabel)
        addConstraintsWithFormat("H:|-10-[v0(140)]-10-|", views: surplusLabel)
        //vertical constraints: the v0, v1, v2 refers to index (20) refers to pixels height
        addConstraintsWithFormat("V:|-5-[v0(20)]-5-[v1(20)]-5-[v2(20)]-[v0]-[v3(20)]-5-[v4(20)]-5-|", views: payDateLabel, payAmountLabel, accountBalanceLabel, totalExpensesLabel, surplusLabel)
        
        //Top constraint
        addConstraint(NSLayoutConstraint(item: payAmountMoneyLabel, attribute: .top, relatedBy: .equal, toItem: payDateLabel, attribute: .bottom, multiplier: 1, constant: 5))
        //left constraint
        addConstraint(NSLayoutConstraint(item: payAmountMoneyLabel, attribute: .left, relatedBy: .equal, toItem: payAmountLabel, attribute: .right, multiplier: 1, constant: 50))
        //right constraint
        addConstraint(NSLayoutConstraint(item: payAmountMoneyLabel, attribute: .right, relatedBy: .equal, toItem: payDateLabel, attribute: .right, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: payAmountMoneyLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
        
    }
}


import SwiftUI

struct MainPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) -> UIViewController {
            return BudgetVC()
        }
        
        func updateUIViewController(_ uiViewController: MainPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) {
            
        }
        
    }
    
}
