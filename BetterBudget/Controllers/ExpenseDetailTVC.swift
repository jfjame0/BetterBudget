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
    @IBOutlet weak var dateTextField: PickerBasedTextField!
    @IBOutlet weak var repeatsPickerTextField: PickerBasedTextField!
    @IBOutlet weak var notesTextView: UITextView!
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
        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
        //        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Problem: The date picker and the repeats picker are both resetting after the detailTVC loads. So, when the viewWillDisappear, the function saveExpense() gets called, and then overwrites the previous data with an empty string for picker and current date for date in the database.
        // Change it so only if the user edits a field, the edit button changes to the 'done' button.
        //When the done button is pressed, saveExpense() is called.
        
        refreshUI()
        
        if titleTextField.isSelected {
            tableView.setEditing(true, animated: true)
        }
        
        //datePicker in line
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        dateTextField.delegate = self
        
        let toolBar2 = UIToolbar()
        toolBar2.barStyle = UIBarStyle.default
        toolBar2.isTranslucent = true
        toolBar2.tintColor = UIColor.green
        toolBar2.sizeToFit()
        
        let doneButton2 = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ExpenseDetailTVC.donePicker))
        
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar2.setItems([spaceButton2, spaceButton2, doneButton2], animated: false)
        toolBar2.isUserInteractionEnabled = true
        dateTextField.inputAccessoryView = toolBar2
        
        //Repeats picker
        
        let frame = self.view.frame
        let repeatsFrame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: 216)
        repeatsSelection = UIPickerView(frame: repeatsFrame)
        repeatsSelection.dataSource = self
        repeatsSelection.delegate = self
        repeatsPickerTextField.inputView = repeatsSelection
        repeatsPickerTextField.delegate = self
        
        // possibly enter the directionField config
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.green
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ExpenseDetailTVC.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        repeatsPickerTextField.inputAccessoryView = toolBar
        
    } 
    
    @objc public func datePickerValueChanged(sender: UIDatePicker) {
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        capturedDate = sender.date
        dateTextField.text = dateFormatter.string(from: sender.date)
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
    
    //Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let repeatsSelection = repeatsPickerData[row]
        capturedPickerData = repeatsSelection
        repeatsPickerTextField.text = capturedPickerData
        
    }
    
    @objc func donePicker() {
        if dateTextField.isFirstResponder {
            dateTextField.resignFirstResponder()
        }
        if repeatsPickerTextField.isFirstResponder {
            repeatsPickerTextField.resignFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //    func textField(_ textField: UITextField,
    //                   shouldChangeCharactersIn range: NSRange,
    //                   replacementString string: String) -> Bool {
    //        return false
    //    }
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        tableView.setEditing(true, animated: true)
    //    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    // MARK: - Editing
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
//        titleTextField.isUserInteractionEnabled = false
       
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
        dateTextField.isUserInteractionEnabled = true
        dateTextField.isEnabled = editing
        repeatsPickerTextField.isUserInteractionEnabled = true
        repeatsPickerTextField.isEnabled = editing
        notesTextView.isUserInteractionEnabled = true
        notesTextView.isEditable = editing
        
        //If the UI is entering the editing state, simply return
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

