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
  
    var expenseModel = ExpensesViewModel()
    
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
        
        if expenseModel.Expensedata != nil {
            
            categoryText.text = expenseModel.Expensedata?.category
            let amount = String(format: "%.2f", expenseModel.Expensedata!.amount )
            amountText.text = amount
            dateDisplay.formatDate()
            MonthText.text = dateDisplay.dateFormatter.string(from: (expenseModel.Expensedata?.date! as Date?)!)
            descriptionText.text = expenseModel.Expensedata?.details
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
        if (expenseModel.isEdited == true ) {
            
            self.performSegue(withIdentifier: "expenseedited", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "saveexpense", sender: self)
        }
        
    }
    
    @IBAction func Save(_ sender: Any) {
        
        if(expenseModel.Expensedata != nil) {
            //update core data
            if (categoryText.text != "" && MonthText.text != "" && amountText.text != "" && descriptionText.text != "") {
                checkUserInput()
                if (expenseModel.isConversionSuccessful == true) {
                   
                    expenseModel.Expensedata?.category = categoryText.text!
                    expenseModel.Expensedata?.amount = Double(amountText.text!)!
                    dateDisplay.formatDate()
                    
                    expenseModel.Expensedata?.date = dateDisplay.dateFormatter.date(from: MonthText.text!)! as NSDate
                    
                    expenseModel.Expensedata?.details = descriptionText.text
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    self.performSegue(withIdentifier: "expenseedited", sender: self)
                }
               

            }
            else{
                alertDisplay.displayalert(usermessage: "All fields are required", view: self)
                
                return
            }
            
        }
            
        else if (categoryText.text != "" && MonthText.text != "" && amountText.text != "" && descriptionText.text != "") {
            checkUserInput()
            
            if (expenseModel.isConversionSuccessful == true) {
                saveexpense()
                
            }
           
            
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
        
        
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return expenseModel.data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        return expenseModel.data[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        categoryText.text = expenseModel.data[row]
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
    //To check if user entered amount and date is valid or not
    
    func checkUserInput() {
        
        if ((expenseModel.numberFormatter.number(from: amountText.text!)?.doubleValue)) != nil {
            
            if ((dateDisplay.dateFormatter.date(from: MonthText.text!) as NSDate?)) != nil {
                expenseModel.isConversionSuccessful = true
                
            }
            else{
                alertDisplay.displayalert(usermessage: "Enter valid date", view: self)
                expenseModel.isConversionSuccessful = false
                return
            }
            
            
        } else{
            alertDisplay.displayalert(usermessage: "Enter valid amount", view: self)
            expenseModel.isConversionSuccessful = false
            return
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
                        
                        
                        if(!expenseModel.data.contains(value.category!)) {
                            expenseModel.data.append(value.category!)
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
