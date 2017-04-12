//
//  ExpensesViewController.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 3/8/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ExpensesViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var Expensedata: Expenses? = nil
    var data: [String] = ["Groceries", "Shopping", "Restaurants"]
    var selectedDate:Date = Date()
    
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var Amount: UILabel!
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var MonthText: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    
    @IBOutlet weak var amountText: UITextField!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categorypickerview()
        
        if Expensedata != nil {
            
            categoryText.text = Expensedata?.category
            amountText.text = String(describing: Expensedata!.amount)
            dateDisplay.formatDate()
            //selectedDate = dateDisplay.dateFormatter.date(from: <#T##String#>)
            MonthText.text = dateDisplay.dateFormatter.string(from: Expensedata?.date! as! Date)
            descriptionText.text = Expensedata?.details
        }
        
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        categoryText.inputView = pickerView
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
        descriptionText.layer.borderColor = UIColor.black.cgColor
        descriptionText.layer.borderWidth = 3
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "saveexpense", sender: self)
    }
    
    @IBAction func Save(_ sender: Any) {
        
        if(Expensedata != nil) {
            //update core data
            Expensedata?.category = categoryText.text!
            Expensedata?.amount = Double(amountText.text!)!
            dateDisplay.formatDate()
            
            Expensedata?.date = dateDisplay.dateFormatter.date(from: MonthText.text!)! as NSDate
            //selectedDate as NSDate
            Expensedata?.details = descriptionText.text
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.performSegue(withIdentifier: "expenseedited", sender: self)
        }
            
        else if (categoryText.text != "" && MonthText.text != "" && amountText.text != "" && descriptionText.text != "") {
            saveexpense()
            self.performSegue(withIdentifier: "saveexpense", sender: self)
            
        }
        else{
            alertDisplay.displayalert(usermessage: "All fields are required", view: self)
            
            return
        }
        
    }
    
    @IBAction func MonthTextfield(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ExpensesViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        dateDisplay.formatDate()
        MonthText.text = dateDisplay.dateFormatter.string(from: sender.date)
        selectedDate = dateDisplay.dateFormatter.date(from: MonthText.text!)!
        
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //let data = result[row] as! Category
        return data[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // let data = result[row] as! Category
        categoryText.text = data[row]
    }
    
    func saveexpense() {
        let sort = NSSortDescriptor(key: "lastname", ascending: true)
        let predicate = NSPredicate(format: "email = %@", userloggedin.userEmail!)
        //To check if database contains user entered value
        databaseModel.fetchRegister.predicate = predicate
        databaseModel.fetchRegister.sortDescriptors = [sort]
        do {
            let result = try databaseModel.context.fetch(databaseModel.fetchRegister)
            print(result.count)
            if (result.count > 0) {
                for object in result {
                    
                    
                    let Expense = Expenses(context: databaseModel.context)
                    Expense.category = categoryText.text
                    Expense.amount = Double(amountText.text!)!
                    Expense.date = dateDisplay.dateFormatter.date(from: MonthText.text!) as NSDate?
                    //selectedDate as NSDate?
                    print(Expense.date!)
                    Expense.details = descriptionText.text
                    
                    Expense.register?.email = object.email
                    object.addToExpense(Expense)
                    
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                }
                
            }
            else{
                print("error")
            }
        } catch {
            print("Fetching Failed")
            
        }
        
    }
    
    
    func categorypickerview()  {
        let sort = NSSortDescriptor(key: "lastname", ascending: true)
        let predicate = NSPredicate(format: "email = %@", userloggedin.userEmail!)
        //To check if database contains user entered value
        databaseModel.fetchRegister.predicate = predicate
        databaseModel.fetchRegister.sortDescriptors = [sort]
        do {
            let result = try databaseModel.context.fetch(databaseModel.fetchRegister)
            print(result.count)
            if (result.count > 0) {
                for object in result {
                    let categoryobject = ((object.category?.allObjects)! as! [Category])
                    
                    for value in categoryobject {
                        
                        
                        if(!data.contains(value.category!)) {
                            data.append(value.category!)
                        }
                        
                    }
                }
                
            }
            else{
                print("error")
            }
        } catch {
            print("Fetching Failed")
            
        }
    }
    
    
    
}
