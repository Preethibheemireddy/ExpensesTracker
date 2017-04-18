//
//  ExpensesTableViewController.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 3/21/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//

import UIKit
import CoreData

class ExpensesTableViewController: UITableViewController {
    @IBOutlet weak var Tableview: UITableView!
    var expense: [Expenses] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        Tableview.estimatedRowHeight = 44.0;
        Tableview.rowHeight = UITableViewAutomaticDimension
        navigation.title = userloggedin.userSelectedDate!
        checkExpenses()
        Tableview.reloadData()
        
    }
    

    @IBOutlet weak var navigation: UINavigationItem!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Home(_ sender: UIBarButtonItem) {
      
        self.performSegue(withIdentifier: "Home", sender: self)
        
    }
    
    
    func checkExpenses() {
        let sort = NSSortDescriptor(key: "date", ascending: true)
        let predicate = NSPredicate(format: "register.email = %@", userloggedin.userEmail!)
        //To check if database contains user entered value
        databaseModel.fetchExpenses.predicate = predicate
        databaseModel.fetchExpenses.sortDescriptors = [sort]
        do {
            let result = try databaseModel.context.fetch(databaseModel.fetchExpenses)
            if (result.count > 0) {
                for object in result {
                    dateDisplay.formatDate()
                    dateDisplay.dateFormatter.dateFormat = "MMMM/YYYY"
                    
                    let Mydate = dateDisplay.dateFormatter.string(from: (object.date as Date?)! )
                    
                    if (Mydate == userloggedin.userSelectedDate!) {
                        expense.append(object)
                        
                    }
                    
                    
                }
                
            }
        } catch {
            print("Fetching Failed")
            
        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return expense.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        // Configure the cell...
        
        let result = expense[indexPath.row]
        let amount = String(format: "%.2f", result.amount )
        cell.amountLabel.text = "$" + amount
        cell.detailsLabel.text = result.details
        dateDisplay.formatDate()
        
        let mydate = dateDisplay.dateFormatter.string(from: (result.date as Date?)!)
        cell.dateLabel.text = mydate
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let deletedCategory = expense[indexPath.row]
            databaseModel.context.delete(deletedCategory as NSManagedObject)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            // delete row from expense array
            expense.remove(at: indexPath.row)
            
            //delete tableview cell
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            Tableview.reloadData()
            
            
        }
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editexpense"){
            
            // let cell = sender as! UITableViewCell
            let indexpath = Tableview.indexPathForSelectedRow!
            let item: ExpensesViewController  = segue.destination as! ExpensesViewController
            let newtask: Expenses = expense[indexpath.row]
            item.expenseModel.Expensedata = newtask
            item.expenseModel.isEdited = true
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
