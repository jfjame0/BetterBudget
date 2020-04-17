//
//  IncomeDetailTVC.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 4/5/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class IncomeDetailTVC: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, NSFetchedResultsControllerDelegate {
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 17)
        return textField
    }()
    
    let amountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 17)
        return textField
    }()
    
    let dateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 17)
        return textField
    }()
    
    let repeatsPickerTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 17)
        return textField
    }()
    
    let notesTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    weak var delegate: IncomeInteractionDelegate?
    
    private lazy var dataProvider: IncomeProvider = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let provider = IncomeProvider(with: appDelegate!.coreDataStack.persistentContainer,
                                      fetchedResultsControllerDelegate: self)
        return provider
    }()
    
    var income: Income?
    var repeatsSelection = UIPickerView()
    let datePicker: UIDatePicker = UIDatePicker()
    var repeatsPickerData: [String] = ["None", "Weekly", "2 Weeks", "Monthly", "2 Months", "6 Months", "Yearly"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        initUI()
        populateUI()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.lightGray.withAlphaComponent(0.1)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionHeader = UILabel()
        switch section {
        case 0:
            sectionHeader.text = "Title"
        case 1:
            sectionHeader.text = "Amount"
        case 2:
            sectionHeader.text = "Pay Date"
        case 3:
            sectionHeader.text = "Repeats"
        case 4:
            sectionHeader.text = "Notes"
        default:
            print("Default Triggered")
        }
        return sectionHeader.text
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            titleTextField.font = UIFont.preferredFont(forTextStyle: .headline)
            titleTextField.adjustsFontForContentSizeCategory = true
            titleTextField.isUserInteractionEnabled = false
            layout(customView: titleTextField, in: cell)
        case 1:
            amountTextField.font = UIFont.preferredFont(forTextStyle: .headline)
            amountTextField.adjustsFontForContentSizeCategory = true
            amountTextField.isUserInteractionEnabled = false
            layout(customView: amountTextField, in: cell)
            amountTextField.delegate = self
            amountTextField.keyboardType = .decimalPad
        case 2:
            dateTextField.font = UIFont.preferredFont(forTextStyle: .headline)
            dateTextField.adjustsFontForContentSizeCategory = true
            dateTextField.isUserInteractionEnabled = false
            layout(customView: dateTextField, in: cell)
        case 3:
            repeatsPickerTextField.font = UIFont.preferredFont(forTextStyle: .headline)
            repeatsPickerTextField.adjustsFontForContentSizeCategory = true
            repeatsPickerTextField.isUserInteractionEnabled = false
            layout(customView: repeatsPickerTextField, in: cell)
        case 4:
            notesTextView.font = UIFont.preferredFont(forTextStyle: .headline)
            notesTextView.adjustsFontForContentSizeCategory = true
            notesTextView.isUserInteractionEnabled = false
            notesTextView.translatesAutoresizingMaskIntoConstraints = false
            layout(customView: notesTextView, in: cell)
            notesTextView.delegate = self
            notesTextView.isScrollEnabled = false
            textViewDidChange(notesTextView)
            
        default:
            print("Default triggered in cellForRowAt indexPath")
        }
        return cell
    }

    private func layout(customView: UIView, in cell: UITableViewCell) {
        cell.contentView.addSubview(customView)
        
        NSLayoutConstraint.activate([
            customView.leadingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor),
            customView.topAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.topAnchor, constant: 8),
            customView.bottomAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.bottomAnchor, constant: -8)
        ])
    }
    
    //Height change when more text is added to notesTextView
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = notesTextView.sizeThatFits(size)
        notesTextView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    private func initUI() {
        
        //build the views for textviews, etc... in here.
        navigationItem.title = income?.title
        navigationItem.rightBarButtonItem = editButtonItem
    
        tableView = .init(frame: .zero, style: .insetGrouped)
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.keyboardDismissMode = .onDrag
        
        //TODO: - notesTextView Bug
        // There is a weird bug: When clicking into the notesTextView, the keyboard shows up. When dragging the keyboard disappears, but then the other fields are not clickable for editing.
        
        //MARK: - Date Picker
        let dateToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        dateToolBar.barStyle = UIBarStyle.default
        dateToolBar.isTranslucent = true
        dateToolBar.tintColor = UIColor.green
        dateToolBar.translatesAutoresizingMaskIntoConstraints = false
        dateToolBar.sizeToFit()
        //Bar Button
        let dateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePickerDate))
        dateToolBar.setItems([dateDoneButton], animated: true)
        
        //Assign Toolbar
        dateTextField.inputAccessoryView = dateToolBar
        // Assign Date picker to textfield
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        
        //MARK: - Repeats Picker
        repeatsPickerTextField.inputView = repeatsSelection
        repeatsPickerTextField.delegate = self
        
        //Picker Toolbar
        let pickerToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        pickerToolBar.barStyle = UIBarStyle.default
        pickerToolBar.isTranslucent = true
        pickerToolBar.tintColor = UIColor.green
        pickerToolBar.translatesAutoresizingMaskIntoConstraints = false
        pickerToolBar.sizeToFit()
        //Bar Button
        let pickerDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePickerRepeats))
        pickerToolBar.setItems([pickerDoneButton], animated: true)
        
        //Assign Toolbar
        repeatsPickerTextField.inputAccessoryView = pickerToolBar
        repeatsSelection.dataSource = self
        repeatsSelection.delegate = self
    }
    
    //Date Picker done button pressed
    @objc func donePickerDate() {
        // After done button pressed on datePicker:
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        
        if dateTextField.isFirstResponder {
            dateTextField.resignFirstResponder()
        }
    }
    
    // Repeats Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return repeatsPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return repeatsPickerData[row]
    }
    
    //Repeats Picker done button pressed
    @objc func donePickerRepeats() {
        
        let selectedRow = repeatsSelection.selectedRow(inComponent: 0)
        repeatsPickerTextField.text = repeatsPickerData[selectedRow]
        
        if repeatsPickerTextField.isFirstResponder {
            repeatsPickerTextField.resignFirstResponder()
        }
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }

    // MARK: - Editing
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        // before calling super.setEditing to recognize the switch to Done, resign the first responder if needed and make sure the title is valid.
        if !editing {
            if titleTextField.isFirstResponder {
                titleTextField.resignFirstResponder()
            }
            if amountTextField.isFirstResponder {
                amountTextField.resignFirstResponder()
            }
            if dateTextField.isFirstResponder {
                dateTextField.resignFirstResponder()
            }
            if repeatsPickerTextField.isFirstResponder {
                repeatsPickerTextField.resignFirstResponder()
            }
            if notesTextView.isFirstResponder {
                notesTextView.resignFirstResponder()
            }
            
            if let title = titleTextField.text, title.isEmpty {
                let alert = UIAlertController(title: "Warning",
                                              message: "The income title is empty",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
            if let amount = amountTextField.text, amount.isEmpty {
                let alert = UIAlertController(title: "Warning",
                                              message: "The income amount is empty",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
            if let date = dateTextField.text, date.isEmpty {
                let alert = UIAlertController(title: "Warning",
                                              message: "The income due date is empty",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
            if let repeats = repeatsPickerTextField.text, repeats.isEmpty {
                let alert = UIAlertController(title: "Warning",
                                              message: "The income repeats field is empty",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
        }
        
        //Call super's implementation to switch the status to editing.
        super.setEditing(editing, animated: false)
        
        //Update the UI based on the editing state.
        titleTextField.isUserInteractionEnabled = true
        titleTextField.isEnabled = editing
        amountTextField.isUserInteractionEnabled = true
        amountTextField.isEnabled = editing
        dateTextField.isUserInteractionEnabled = true
        dateTextField.isEnabled = editing
        repeatsPickerTextField.isUserInteractionEnabled = true
        repeatsPickerTextField.isEnabled = editing
        notesTextView.isUserInteractionEnabled = true
        notesTextView.isEditable = editing
        
        //If the UI is entering the editing state, simply return
        guard !isEditing, let income = income else { return }
        
        //MARK: - Save Context
        let context = income.managedObjectContext!
        
        context.performAndWait {
            if let title = titleTextField.text,
                let amount = amountTextField.text {
                income.title = title
                income.amount = Double(amount)!
                income.payDate = datePicker.date
                
                let selectedRow = repeatsSelection.selectedRow(inComponent: 0)
                income.repeats = repeatsPickerData[selectedRow]
                
                income.notes = notesTextView.text
                context.save(with: .updateIncome)
            } else {
                let alert = UIAlertController(title: "Error",
                                              message: "Something went wrong. The income didn't save. Try again.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
        }

        //Update title if it has changed
        func titleDidChange() {
            navigationItem.title = income.title
        }
        titleDidChange()
    }
}

//MARK: - TableView Data Source & TableView Delegate Methods

extension IncomeDetailTVC {
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension IncomeDetailTVC {
    
    func populateUI() {
        navigationItem.rightBarButtonItem?.isEnabled = income == nil ? false : true
        //Title
        titleTextField.text = income?.title ?? ""
        //Amount
        if let amount = income?.amount {
            amountTextField.text = String(format: "%.0f", amount)
        } else {
            amountTextField.text = ""
        }
        //Date
        if let currentPayDate = income?.payDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            dateTextField.text = formatter.string(from: currentPayDate)
            datePicker.date = currentPayDate
        } else {
            dateTextField.text = ""
        }
        //Repeats
        if let repeats = income?.repeats {
            //["None", "Weekly", "2 Weeks", "Monthly", "2 Months", "6 Months", "Yearly"]
            repeatsPickerTextField.text = repeats
            let index = repeatsPickerData.firstIndex(of: repeats) ?? 0
            repeatsSelection.selectRow(index, inComponent: 0, animated: false)
        } else {
            repeatsPickerTextField.text = "None"
        }
        //Notes
        notesTextView.text = income?.notes ?? ""
        tableView.reloadData()
    }
}

