//
//  RegisterViewController.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 3/8/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//


                
import UIKit
import CoreData

class RegisterViewController: UIViewController {
    var expenseModel = ExpensesViewModel()
    
    
    @IBOutlet weak var ConfirmPassword: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Lastname: UITextField!
    @IBOutlet weak var Firstname: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func Alreadyhavaaccount(_ sender: UIButton) {
    }
    
    func Registeruser() {
        if (Firstname.text != "" && Lastname.text != "" && Password.text != "" && ConfirmPassword.text != "" && Email.text != "") {
            
            if (Password.text == ConfirmPassword.text) {
                let sort = NSSortDescriptor(key: "lastname", ascending: true)
                let predicate = NSPredicate(format: "email = %@", Email.text!)
                //To check if database contains user entered value
                databaseModel.fetchRegister.predicate = predicate
                databaseModel.fetchRegister.sortDescriptors = [sort]
                
                
                do {
                    let result = try databaseModel.context.fetch(databaseModel.fetchRegister)
                    if (result.count > 0) {
                        alertDisplay.displayalert(usermessage: "User with this Email Id already exists", view: self)
                        
                        return
                    }
                    let RegisterData = Register(context: databaseModel.context)
                    
                    RegisterData.email = Email.text
                    RegisterData.lastname = Lastname.text
                    RegisterData.firstname = Firstname.text
                    RegisterData.password = Password.text
                    RegisterData.confirmPassword = ConfirmPassword.text
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    
                    for item in expenseModel.data {
                        let categoryData = Category(context: databaseModel.context)
                        categoryData.setValue(item, forKey: "category")
                        categoryData.register?.email = RegisterData.email
                         RegisterData.addToCategory(categoryData)
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    }
                    
                    
                    
                } catch {
                    print("Fetching Failed")
                    return
                }
                
                
                
            }
            else{
                alertDisplay.displayalert(usermessage: "Passwords do not match", view: self)
                
                return
            }
        }
        else{
            alertDisplay.displayalert(usermessage: "All the fields are required", view: self)
            
            return
        }
    }
    
    
    @IBAction func UserRegistration(_ sender: UIButton) {
        Registeruser()
        self.performSegue(withIdentifier: "Registered", sender: self)
    }
    
       
}
