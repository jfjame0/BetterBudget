//
//  ExpenseDetailTVC.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 3/22/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class ExpenseDetailTVC: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, NSFetchedResultsControllerDelegate {
    @IBOutlet var table: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var repeatsPickerTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    //TODO: - Add a prefix label in interfacebuilder, in the amountCell that holds a currency symbol:
    //    prefixLabel.text = "+" + NSLocale.defaultCurrency
    //    prefixLabel.textColor = UIColor.green
    
    weak var delegate: ExpenseInteractionDelegate?
    
    private lazy var dataProvider: ExpenseProvider = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let provider = ExpenseProvider(with: appDelegate!.coreDataStack.persistentContainer,
                                       fetchedResultsControllerDelegate: self)
        return provider
    }()
    
    var expense: Expense?
    let dueDatePickerSelection = UIDatePicker()
    var repeatsSelection = UIPickerView()
    let datePicker: UIDatePicker = UIDatePicker()
    var capturedDate: Date = Date()
    var capturedPickerData: String = String()
    var doneButton: UIBarButtonItem = UIBarButtonItem()
    var repeatsPickerData: [String] = ["None", "Weekly", "2 Weeks", "Monthly", "2 Months", "6 Months", "Yearly"]
    
    //MARK: - AddExpenseTVC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.title = expense?.title
        
        refreshUI()
        
    } 
    
    //Date Picker
//    @objc public func datePickerValueChanged(sender: UIDatePicker) {
//
//        let dateFormatter: DateFormatter = DateFormatter()
//        dateFormatter.dateStyle = DateFormatter.Style.short
//        dateFormatter.timeStyle = DateFormatter.Style.none
//        capturedDate = sender.date
//
//    }
    
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
    
    //Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let repeatsSelection = repeatsPickerData[row]
        capturedPickerData = repeatsSelection
//        repeatsPickerTextField.text = capturedPickerData
    }
    
    //Date Picker done button pressed
    @objc func donePickerDate() {
        // After done button pressed on datePicker:
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        //TODO: - Captured date keeps replacing current date with date pickers date
        
        //capturedDate
        let dateString = dateTextField.text
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM-dd-yyyy"
        capturedDate = dateFormatter.date(from: dateString!)!
        
        if dateTextField.isFirstResponder {
            dateTextField.resignFirstResponder()
        }
        
        self.view.endEditing(true)
    }
    
//TODO: - Repeats Picker done button pressed
    @objc func donePickerRepeats() {

        repeatsPickerTextField.text = "\(capturedPickerData)"

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
                                              message: "The expense title is empty",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
            if let amount = amountTextField.text, amount.isEmpty {
                let alert = UIAlertController(title: "Warning",
                                              message: "The expense amount is empty",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
            if let date = dateTextField.text, date.isEmpty {
                let alert = UIAlertController(title: "Warning",
                                              message: "The expense due date is empty",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
            
            if let repeats = repeatsPickerTextField.text, repeats.isEmpty {
                let alert = UIAlertController(title: "Warning",
                                              message: "The expense repeats field is empty",
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
            
      //MARK: - Repeats Picker
        
        let frame = self.view.frame
        let repeatsFrame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: 216)
        repeatsSelection = UIPickerView(frame: repeatsFrame)
        repeatsSelection.dataSource = self
        repeatsSelection.delegate = self
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
        
        //If the UI is entering the editing state, simply return
        guard !isEditing, let expense = expense else { return }
        
        //MARK: - Save Context
        let context = expense.managedObjectContext!
        
        context.performAndWait {
            if let title = titleTextField.text,
                let amount = amountTextField.text {
                expense.title = title
                expense.amount = Double(amount)!
                expense.dueDate = capturedDate
                expense.repeats = capturedPickerData
                expense.notes = notesTextView.text
                context.save(with: .updateExpense)
            } else {
                let alert = UIAlertController(title: "Error",
                                              message: "Something went wrong. The expense didn't save. Try again.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
        }
    }
}

//MARK: - TableView Data Source & TableView Delegate Methods

extension ExpenseDetailTVC {
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ExpenseDetailTVC {
    
    func refreshUI() {
        navigationItem.rightBarButtonItem?.isEnabled = expense == nil ? false : true
        //Title
        titleTextField.text = expense?.title ?? ""
        //Amount
        if let amount = expense?.amount {
            amountTextField.text = String(amount)
        } else {
            amountTextField.text = ""
        }
        //Date
        if let currentDueDate = expense?.dueDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            dateTextField.text = formatter.string(from: currentDueDate)
        } else {
            dateTextField.text = ""
        }
        //Repeats
        repeatsPickerTextField.text = expense?.repeats ?? "None"
        
        //Notes
        notesTextView.text = expense?.notes ?? ""
        tableView.reloadData()
    }
}
/*

extension ExpenseDetailTVC {
    
    func saveExpense() {
        
        guard !isEditing, let expense = expense else { return }
        
        let context = expense.managedObjectContext!
        
        context.performAndWait {
            if let title = titleTextField.text,
                let amount = amountTextField.text {
                expense.title = title
                expense.amount = Double(amount)!
                expense.dueDate = capturedDate
                expense.repeats = capturedPickerData
                expense.notes = notesTextView.text
                context.save(with: .updateExpense)
            } else {
                return //Put a Warning Alert
            }
        }
    }
}
*/
