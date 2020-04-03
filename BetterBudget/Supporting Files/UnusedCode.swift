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
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 */

