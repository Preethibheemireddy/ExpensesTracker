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

class ExpensesViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{
  
    var expenseModel = ExpensesViewModel()
    var categories: [Category] = []
    
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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ExpensesViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        checkCategory()
        
       // categorypickerview()
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        /*if (expenseModel.isEdited == true ) {
            
            self.navigationController?.popViewController(animated: true)
            //self.performSegue(withIdentifier: "expenseedited", sender: self)
        }
        else{
            self.navigationController?.popViewController(animated: true)
           // self.performSegue(withIdentifier: "saveexpense", sender: self)
        }*/
        
        self.navigationController?.popViewController(animated: true)
        
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
        return categories.count
            //expenseModel.data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            let category = categories[row]
            return category.category
       
            //expenseModel.data[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            let category = categories[row]
            categoryText.text = category.category
        
            //expenseModel.data[row]
    }
    
    func saveexpense() {
        let sort = NSSortDescriptor(key: "lastname", ascending: true)
        let predicate = NSPredicate(format: "email = %@", userloggedin.userEmail!)
        //To check if database contains user entered value
        databaseModel.fetchRegister.predicate = predicate
        databaseModel.fetchRegister.sortDescriptors = [sort]
        do {
            let result = try databaseModel.context.fetch(databaseModel.fetchRegister)
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
    
    
    func checkCategory() {
        // To sort categories with category
        let sort = NSSortDescriptor(key: "category", ascending: true)
        // To predicate category database using email ID
        let predicate = NSPredicate(format: "register.email = %@", userloggedin.userEmail!)
        databaseModel.fetchCategory.predicate = predicate
        databaseModel.fetchCategory.sortDescriptors = [sort]
        do {
            categories = try databaseModel.context.fetch(databaseModel.fetchCategory)
            
            
        } catch {
            print("Fetching Failed")
            
        }
        
    }
    
    
    
    
    
}
