//
//  HomeViewController.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 6/3/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var myobjects = [expenses]()
    var myExpenses: Dictionary<String, Double> = [:]

    @IBOutlet weak var Menu: UIBarButtonItem!
    @IBOutlet weak var AddExpenses: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.brown

        checkExpenses()
        //To append key, values of dictionary into myobjects array
        
        for (key, value) in myExpenses {
            
            myobjects.append(expenses(date: key, amount: value))
        }
        
        TableView.reloadData()
        
        TableView.estimatedRowHeight = 44.0;
        TableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBar.barTintColor = UIColor.brown
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        
        TableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var TableView: UITableView!
    
    @IBAction func MenuAction(_ sender: UIBarButtonItem) {
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    
    @IBAction func AddExpensesAction(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowExpenses", sender: self)
    }
    
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue) {
        myExpenses.removeAll()
        myobjects.removeAll()
        checkExpenses()
        //To append key, values of dictionary into myobjects array
        
        for (key, value) in myExpenses {
            
            myobjects.append(expenses(date: key, amount: value))
        }
        TableView.reloadData()
        
    }

       
   func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myobjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
        let value = myobjects[indexPath.row]
        cell.textLabel?.text = value.date
        let amount = String(format: "%.2f", value.amount)
        
        cell.detailTextLabel?.text = "$" + amount

        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = myobjects[indexPath.row]
        userloggedin.userSelectedDate = value.date
        
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
                    if (!myExpenses.isEmpty) {
                        // if dictionary does not contain mydate add new expense.
                        if (myExpenses[Mydate] == nil) {
                            myExpenses[Mydate] = object.amount
                        }
                            
                            //if dictionary contains mydate as key then update its value by adding amount
                        else{
                            myExpenses[Mydate] = myExpenses[Mydate]! + object.amount
                        }
                        
                        
                    }
                    else {
                        //  if dictionary is empty add new expense to it
                        myExpenses[Mydate] = object.amount
                        
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
