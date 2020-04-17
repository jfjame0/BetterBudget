//
//  UnusedCode.swift
//  BetterBudget
//
//  Created by JOHN JAMES III on 3/24/20.
//  Copyright © 2020 JOHN JAMES III. All rights reserved.
//
// Marked for Deletion, but stored here in case it's needed in the future.

/*
 
 
 @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
     displayForm(message: "Add Expense")
 }
  
    
   //Variables titleTextField, and amountTextField were made global at top of Class
     func displayForm(message: String) {
         
         //Create Alert
         let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
         
         // Create cancel button
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
         
         // Create save button
         // When the closure block is created (action) refers to the name of the completion handler.
         let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
             // What will happen once the user clicks the Add Item button on the UIAlert
             //Put some validation code, in case the user enters nothing (no text)
             // Now use the context constanst by grabbing the Expense object's context
             let newExpense = Expense(context: self.context)
             newExpense.title = self.titleTextField.text!
     //TODO: - This part is tricky, ask Denis to double check this
             newExpense.amount = Double(self.amountTextField.text!)!
             
 //            if((self.titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! || self.amountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! ) {
 //                //If this code is run, then that means at least one of the fields doesn't have a value
 //                self.titleTextField.text = ""
 //                self.amountTextField.text = ""
 //
 //                self.displayForm(message: "One of the values entered was invalid.")
 //
 //            }
             
             self.itemArray.append(newExpense)
             
             self.saveExpenses()
             
         }
         
         // add button to alert
         alert.addAction(cancelAction)
         alert.addAction(saveAction)
         
         //create titleTextField
         alert.addTextField(configurationHandler: {(textField: UITextField!) in
             textField.placeholder = "Expense Name"
             self.titleTextField = textField
         })
         
         //create amountTextField
         alert.addTextField(configurationHandler: {(textField: UITextField!) in
             textField.placeholder = "Amount"
             self.amountTextField = textField
         })
         
         //Show the alert:
         self.present(alert, animated: true, completion: nil)
         
     }
 
 
 
 /*
 extension ExpensesTVC: UISearchBarDelegate {
     
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         
         let request: NSFetchRequest<Expense> = Expense.fetchRequest()
         
         request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
         
         request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
         
         loadExpenses(with: request)
         
     }
     
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         if searchBar.text?.count == 0 {
             loadExpenses()
             
             DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
             }
             
         }
     }
     
 }
 */

 /*  File Path for custom plist: /Users/jj/Library/Developer/CoreSimulator/Devices/5D6A2F13-AAC7-4BA1-8116-820FE2CEABD8/data/Containers/Data/Application/B2023ADB-A28A-4845-BC6C-3F33CD687902/Documents/Expenses.plist
  */
 /*  File Path for Core Data generated classes (models)
     // Xcode will not display these files in the left hand pane as core data creates these files and stores them in the background. They are managed through the: BetterBudget.xcdatamodld
 /Users/jj/Library/Developer/Xcode/DerivedData/BetterBudget-dgzxxwjzzcginnakinqxfojnjpjd/Build/Intermediates.noindex/BetterBudget.build/Debug-iphonesimulator/BetterBudget.build/DerivedSources/CoreDataGenerated/BetterBudget/Expense+CoreDataProperties.swift
  
     File Path for DataModel.sqlite:
  /Users/jj/Library/Developer/CoreSimulator/Devices/5D6A2F13-AAC7-4BA1-8116-820FE2CEABD8/data/Containers/Data/Application/2EA5E05D-2AEE-40F7-8CBD-17CB8729480F/Documents/

 */
 
 /*
  // Override to support conditional editing of the table view.
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
  // Return false if you do not want the specified item to be editable.
  return true
  }
  */
 
 /*
  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
  if editingStyle == .delete {
  // Delete the row from the data source
  tableView.deleteRows(at: [indexPath], with: .fade)
  } else if editingStyle == .insert {
  // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }
  }
  */
 
 /*
  // Override to support rearranging the table view.
  override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
  
  }
  */
 
 /*
  // Override to support conditional rearranging of the table view.
  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
  // Return false if you do not want the item to be re-orderable.
  return true
  }
  */
 
 /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  // Get the new view controller using segue.destination.
  // Pass the selected object to the new view controller.
  }
  */
 
 
 /*
    
 Unused code from ExpensesTVC
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ExpenseDetail", sender: indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ExpenseDetail" {
            //This method populates selectedExpense with the indexPath.row's data. (I hope)
            let destinationTVC = segue.destination as! AddExpenseTVC
            // returns nil or index path representing section and row of selection.
            if let indexPath = tableView.indexPathForSelectedRow {
                //Var expense has to be created in the ExpenseDetailTVC
                destinationTVC.expense = itemArray[indexPath.row]
            }
        }
    }

    
    //MARK: - Model Manipulation Methods
    
    func saveExpenses() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadExpenses(with request: NSFetchRequest<Expense> = Expense.fetchRequest()) {
        //Must explicity declare data type <DataType>, just like you should always explicitly declare data types because swift moves faster when you do.
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        
        self.tableView.reloadData()
    }
     */
 
 /*

 extension ExpenseDetailTVC {
     
     @IBInspectable var doneAccessory: Bool {
         get{
             return self.doneAccessory
         }
         set (hasDone) {
             if hasDone {
                 addDoneButtonOnKeyboard()
             }
         }
     }
     
     func addDoneButtonOnKeyboard() {
         
         let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
         doneToolbar.barStyle = .default
         
         let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
         let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
         
         let items = [flexSpace, done]
         doneToolbar.items = items
         doneToolbar.sizeToFit()
         
         self.inputAccessoryView = doneToolbar
     }
     
     func doneButtonAction() {
         self.resignFirstResponder()
     }
     
     
 }
 */
 
 let titleHeaderLabel: UILabel = {
     let label = UILabel()
     label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
     label.translatesAutoresizingMaskIntoConstraints = false
     label.text = "Title"
     label.textAlignment = .left
     //        label.textColor = UIColor.gray
     //        label.font = label.font?.withSize(17)
     return label
 }()
 
 let titleTextField: UITextField = {
     let textField = UITextField()
     textField.translatesAutoresizingMaskIntoConstraints = false
     textField.font = UIFont.systemFont(ofSize: 17)
     //        textField.text = "titleTextField Test"
     return textField
 }()
 
 let amountHeaderLabel: UILabel = {
     let label = UILabel()
     label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
     label.translatesAutoresizingMaskIntoConstraints = false
     label.text = "Amount"
     label.textAlignment = .left
     return label
 }()
 
 let amountTextField: UITextField = {
     let textField = UITextField()
     textField.translatesAutoresizingMaskIntoConstraints = false
     textField.font = UIFont.systemFont(ofSize: 17)
     //        textField.text = "$ 150.00 amountTextField Test"
     return textField
 }()
 
 let dateHeaderLabel: UILabel = {
     let label = UILabel()
     label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
     label.translatesAutoresizingMaskIntoConstraints = false
     label.text = "Date"
     label.textAlignment = .left
     return label
 }()
 
 let dateTextField: UITextField = {
     let textField = UITextField()
     textField.translatesAutoresizingMaskIntoConstraints = false
     textField.font = UIFont.systemFont(ofSize: 17)
     //        textField.text = "11/26/2020 Test"
     return textField
 }()
 
 let repeatsHeaderLabel: UILabel = {
     let label = UILabel()
     label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
     label.translatesAutoresizingMaskIntoConstraints = false
     label.text = "Repeats"
     label.textAlignment = .left
     return label
 }()
 
 let repeatsPickerTextField: UITextField = {
     let textField = UITextField()
     textField.translatesAutoresizingMaskIntoConstraints = false
     textField.font = UIFont.systemFont(ofSize: 17)
     //        textField.text = "Monthly Test"
     return textField
 }()
 
 let notesHeaderLabel: UILabel = {
     let label = UILabel()
     label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
     label.translatesAutoresizingMaskIntoConstraints = false
     label.text = "Notes"
     label.textAlignment = .left
     return label
 }()
 
 let notesTextView: UITextView = {
     let textView = UITextView()
     textView.translatesAutoresizingMaskIntoConstraints = false
     textView.font = UIFont.systemFont(ofSize: 17)
     //        textView.text = "Some notes are written in here."
     return textView
 }()
 
 
 
 contentView.addSubview(titleHeaderLabel)
 view.addSubview(titleTextField)
 view.addSubview(amountHeaderLabel)
 view.addSubview(amountTextField)
 view.addSubview(dateHeaderLabel)
 view.addSubview(dateTextField)
 view.addSubview(repeatsHeaderLabel)
 view.addSubview(repeatsPickerTextField)
 view.addSubview(notesHeaderLabel)
 view.addSubview(notesTextView)
 
 //Set contstraints
 [
     titleTextField.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
     titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
     titleTextField.leadingAnchor.constraint(equalTo: view.trailingAnchor),
     titleTextField.heightAnchor.constraint(equalToConstant: 44)
     ].forEach{ $0.isActive = true }
 
 [
     amountTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
     amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
     amountTextField.leadingAnchor.constraint(equalTo: view.trailingAnchor),
     amountTextField.heightAnchor.constraint(equalToConstant: 44)
     ].forEach{ $0.isActive = true }
 
 [
     dateTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
     dateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
     dateTextField.leadingAnchor.constraint(equalTo: view.trailingAnchor),
     dateTextField.heightAnchor.constraint(equalToConstant: 44)
     ].forEach{ $0.isActive = true }
 
 [
     repeatsPickerTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
     repeatsPickerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
     repeatsPickerTextField.leadingAnchor.constraint(equalTo: view.trailingAnchor),
     repeatsPickerTextField.heightAnchor.constraint(equalToConstant: 44)
     ].forEach{ $0.isActive = true }
 
 [
     notesTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
     notesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
     notesTextView.leadingAnchor.constraint(equalTo: view.trailingAnchor),
     notesTextView.heightAnchor.constraint(equalToConstant: 44)
     ].forEach{ $0.isActive = true }
 
 
 override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         switch section {
         case 0:
             if let titleHeader = titleHeaderLabel.text {
                 return titleHeader
             }
         case 1:
             if let amountHeader = amountHeaderLabel.text {
                 return amountHeader
             }
         case 2:
             if let dateHeader = dateHeaderLabel.text {
                 return dateHeader
             }
         case 3:
             if let repeatsHeader = repeatsHeaderLabel.text {
                 return repeatsHeader
             }
         case 4:
             if let notesHeader = notesHeaderLabel.text {
                 return notesHeader
             }
         default:
             return "Default"
         }
         return "Section: \(String())"
     }
     
 //    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
 //        switch section {
 //        case 0: return titleHeaderLabel
 //        case 1: return amountHeaderLabel
 //        case 2: return dateHeaderLabel
 //        case 3: return repeatsHeaderLabel
 //        case 4: return notesHeaderLabel
 //        default:
 //            return nil
 //        }
 //    }
 
 
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = UITableViewCell()
         
         switch indexPath.row {
         case 0:
             cell.contentView.addSubview(titleTextField)
         case 1:
             cell.contentView.addSubview(amountTextField)
         case 2:
             cell.contentView.addSubview(dateTextField)
         case 3:
             cell.contentView.addSubview(repeatsPickerTextField)
         case 4:
             cell.contentView.addSubview(notesTextView)
         default:
             print("Default triggered in cellForRowAt indexPath")
 //            cell.contentView.addSubview(UIView()) //Can I do this?
         }
         return cell
     }
 
 
             //            titleTextField.leadingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
             //            titleTextField.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
             //            titleTextField.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: cell.contentView.layoutMarginsGuide.topAnchor, multiplier: 1).isActive = true
             //            cell.contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: titleTextField.lastBaselineAnchor, multiplier: 1).isActive = true
             
 //            amountTextField.leadingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
 //            amountTextField.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
 //            amountTextField.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: cell.contentView.layoutMarginsGuide.topAnchor, multiplier: 1).isActive = true
 //            cell.contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: amountTextField.lastBaselineAnchor, multiplier: 1).isActive = true
             
             //            dateTextField.leadingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
             //            dateTextField.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
             //            dateTextField.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: cell.contentView.layoutMarginsGuide.topAnchor, multiplier: 1).isActive = true
             //            cell.contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: dateTextField.lastBaselineAnchor, multiplier: 1).isActive = true
             
             //            repeatsPickerTextField.leadingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
             //            repeatsPickerTextField.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
             //            repeatsPickerTextField.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: cell.contentView.layoutMarginsGuide.topAnchor, multiplier: 1).isActive = true
             //            cell.contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: repeatsPickerTextField.lastBaselineAnchor, multiplier: 1).isActive = true
             
             //            notesTextField.leadingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
             //            notesTextField.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
             //            notesTextField.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: cell.contentView.layoutMarginsGuide.topAnchor, multiplier: 1).isActive = true
             //            cell.contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: notesTextField.lastBaselineAnchor, multiplier: 1).isActive = true
 
 
 */

