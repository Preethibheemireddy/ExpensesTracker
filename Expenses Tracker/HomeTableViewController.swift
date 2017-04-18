//
//  HomeTableViewController.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 3/8/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController {
    
    var myobjects = [expenses]()
    var mytotal: Dictionary<String, Double> = [:]
    

    @IBOutlet weak var addExpenses: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var Tableview: UITableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Tableview.estimatedRowHeight = 44.0;
        Tableview.rowHeight = UITableViewAutomaticDimension
       self.navigationController?.navigationBar.barTintColor = UIColor.brown
        self.navigationController?.toolbar.barTintColor = UIColor.brown
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        checkExpenses()
        
        for (key, value) in mytotal {
            
            
            myobjects.append(expenses(date: key, amount: value))
        }
        
        
        
        Tableview.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func MenuButton(_ sender: Any) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    
    @IBAction func AddExpenses(_ sender: Any) {
        performSegue(withIdentifier: "Expenses", sender: self)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return myobjects.count
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Homecell", for: indexPath)
        
        // Configure the cell...
        let value = myobjects[indexPath.row]
        cell.textLabel?.text = value.date
        let amount = String(format: "%.2f", value.amount)
        
        cell.detailTextLabel?.text = "$" + amount
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = myobjects[indexPath.row]
        userloggedin.userSelectedDate = value.date
        
        print(userloggedin.userSelectedDate!)
    }
    
    func checkExpenses() {
        // To sort expenses by date
        let sort = NSSortDescriptor(key: "date", ascending: true)
        // To predicate data using email ID
        let predicate = NSPredicate(format: "register.email = %@", userloggedin.userEmail!)
        databaseModel.fetchExpenses.predicate = predicate
        databaseModel.fetchExpenses.sortDescriptors = [sort]
        do {
            let result = try databaseModel.context.fetch(databaseModel.fetchExpenses)
            if (result.count > 0) {
                for object in result {
                    dateDisplay.formatDate()
                    // To diaplay date in month/year format
                    dateDisplay.dateFormatter.dateFormat = "MMMM/YYYY"
                    
                    let Mydate = dateDisplay.dateFormatter.string(from: object.date! as Date )
                    // To check if mytotal dictionary contains any data
                    if (!mytotal.isEmpty) {
                        // if mytotal dictionary is not empty loop through keys to check if key is equal to mydate
                        for key in mytotal.keys {
                            //  if key is not equal to mydate
                            if (key != Mydate ) {
                                // add expense date to mytotal dictionary
                                mytotal[Mydate] = object.amount
                            }
                            else{
                                // if key is equal to mydate update the amount of a date in the dictionary
                                mytotal[Mydate] = mytotal[Mydate]! + object.amount
                                
                            }
                        }
                        
                    }
                    else {
                        //  if dictionary is empty add new expense to it
                        mytotal[Mydate] = object.amount
                        
                    }
                    
                    
                }
                
                
                
            }
            
        } catch {
            print("Fetching Failed")
            
        }
        
        
    }
    struct expenses {
        var date: String
        var amount:Double
    }
    
    
    
    
    
    
}
