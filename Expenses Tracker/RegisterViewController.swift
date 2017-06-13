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
        //To dismiss keyboard
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
        // if textfields are not nil
        if (Firstname.text != "" && Lastname.text != "" && Password.text != "" && ConfirmPassword.text != "" && Email.text != "")
        {
            //if password is equal to confirm password
            if (Password.text == ConfirmPassword.text)
            {
                //to sort register table using lastname
                let sort = NSSortDescriptor(key: "lastname", ascending: true)
                //To predicte register database using emailId
                let predicate = NSPredicate(format: "email = %@", Email.text!)
                //To check if database contains user entered value
                databaseModel.fetchRegister.predicate = predicate
                databaseModel.fetchRegister.sortDescriptors = [sort]
                
                
                do {
                    let result = try databaseModel.context.fetch(databaseModel.fetchRegister)
                    //if user already exist in database raise alert
                    if (result.count > 0) {
                        alertDisplay.displayalert(usermessage: "User with this Email Id already exists", view: self)
                        
                        return
                    }
                    //create new user
                    let RegisterData = Register(context: databaseModel.context)
                    
                    RegisterData.email = Email.text
                    RegisterData.lastname = Lastname.text
                    RegisterData.firstname = Firstname.text
                    RegisterData.password = Password.text
                    RegisterData.confirmPassword = ConfirmPassword.text
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    //loop through items in expensesmodel.data array to assign default categories to registered user
                    for item in expenseModel.data {
                        //create category database
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
                //if passwords do not match
            else{
                alertDisplay.displayalert(usermessage: "Passwords do not match", view: self)
                
                return
            }
        }
            //if any textfield is empty
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
