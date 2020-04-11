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

class IncomeDetailTVC: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, NSFetchedResultsControllerDelegate {
    
    let cellID = "CellID123456"
    
    //TODO: - Change TableView Cells to 5 dyanmica prototypes programmatically.
    //TODO: - Change all these IBOutlets into programmatically created elements
    var table = UITableView()
    var titleTextField: UITextField = UITextField()
    var amountTextField = UITextField()
    var dateTextField = UITextField()
    var repeatsPickerTextField = UITextField()
    var notesTextView = UITextView()

    weak var delegate: IncomeInteractionDelegate?
    
    private lazy var dataProvider: IncomeProvider = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let provider = IncomeProvider(with: appDelegate!.coreDataStack.persistentContainer,
                                       fetchedResultsControllerDelegate: self)
        return provider
    }()
    
    var income: Income?
//    let payDatePickerSelection = UIDatePicker()
    var repeatsSelection = UIPickerView()
    let datePicker: UIDatePicker = UIDatePicker()
    var repeatsPickerData: [String] = ["None", "Weekly", "2 Weeks", "Monthly", "2 Months", "6 Months", "Yearly"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       
        
        
        
        
//        initUI()
//        populateUI()
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Header"
        label.backgroundColor = UIColor.lightGray
        return label
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        return cell
    }
    
    private func initUI() {
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.title = income?.title
        
        //MARK: - Date Picker
        let dateToolBar = UIToolbar()
        dateToolBar.barStyle = UIBarStyle.default
        dateToolBar.isTranslucent = true
        dateToolBar.tintColor = UIColor.green
        dateToolBar.sizeToFit()
        
        //Bar Button
        let dateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePickerDate))
        dateToolBar.setItems([dateDoneButton], animated: true)
        
        //Assign Toolbar
        dateTextField.inputAccessoryView = dateToolBar
        
        // Assign Date picker to textfield
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        // testing .setDate below with captureDate to see if it poulates.
        
        //MARK: - Repeats Picker
        
        //        let frame = self.view.frame
        //        let repeatsFrame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: 216)
        //        repeatsSelection = UIPickerView(frame: repeatsFrame)
        //        repeatsSelection = UIPickerView()
        repeatsPickerTextField.inputView = repeatsSelection
        repeatsPickerTextField.delegate = self
        
        //Picker Toolbar
        let pickerToolBar = UIToolbar()
        pickerToolBar.barStyle = UIBarStyle.default
        pickerToolBar.isTranslucent = true
        pickerToolBar.tintColor = UIColor.green
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
            if notesTextView.isFirstResponder {
                notesTextView.resignFirstResponder()
            }
            if dateTextField.isFirstResponder {
                dateTextField.resignFirstResponder()
            }
            if repeatsPickerTextField.isFirstResponder {
                repeatsPickerTextField.resignFirstResponder()
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
        // All fields are locked with isUserInteractionEnabled set to false in the storyboard, until super.setEditing is called, then we set it to true.
        titleTextField.isUserInteractionEnabled = true
        titleTextField.isEnabled = editing
        amountTextField.isUserInteractionEnabled = true
        amountTextField.isEnabled = editing
        notesTextView.isUserInteractionEnabled = true
        notesTextView.isEditable = editing
        dateTextField.isUserInteractionEnabled = true
        dateTextField.isEnabled = editing
        repeatsPickerTextField.isUserInteractionEnabled = true
        repeatsPickerTextField.isEnabled = editing
        
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

