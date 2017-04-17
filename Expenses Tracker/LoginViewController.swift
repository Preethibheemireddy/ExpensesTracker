//
//  LoginViewController.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 3/8/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//

import UIKit
import CoreData
import Foundation
class LoginViewController: UIViewController {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UITextField!
    let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
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
    
    @IBAction func Login(_ sender: Any) {
        
        if (login.text != "" && password.text != "") {
            //To check if email exists in database
            let login = checkEmail()
            //if user exists perform login
            if (login == true) {
            //To set login.text as current useremail
                UserDefaults.standard.setValue(self.login.text, forKey: "userEmail")
                //To set user is logged in
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
                //To use the current user email locally
                userloggedin.userEmail = UserDefaults.standard.value(forKey: "userEmail") as? String
            
                self.performSegue(withIdentifier: "Loggedin", sender: self)
                //To show slide menu
                slidemenu()
                
                
            }
            
        }
            //if all fields are not entered show alert
        else{
            alertDisplay.displayalert(usermessage: "All fields are required", view: self)
            
        }
        
    }
    
    func checkEmail() -> Bool {
        var LoginSuccess: Bool = false
        //To sort by lastname
        let sort = NSSortDescriptor(key: "lastname", ascending: true)
        //To predicate using emailID
        let predicate = NSPredicate(format: "email = %@", login.text!)
        //To check if database contains user entered emailID
        databaseModel.fetchRegister.predicate = predicate
        databaseModel.fetchRegister.sortDescriptors = [sort]
        do {
            let result = try databaseModel.context.fetch(databaseModel.fetchRegister)
            if (result.count > 0) {
                for object in result {
                    //if password and email do not match show alert
                    if (password.text != object.password) {
                        alertDisplay.displayalert(usermessage: "Email/Password does not match", view: self)
                        return LoginSuccess
                    }
                    //login is success
                    LoginSuccess = true
                    
                }
                
            }
                //if the user email does not exist in database
            else{
                alertDisplay.displayalert(usermessage: "User with this Email Id does not exist", view: self)
                return LoginSuccess
            }
        } catch {
            print("Fetching Failed")
            return LoginSuccess
        }
        
        return LoginSuccess
}
    func slidemenu() {
        let rootViewController = appdelegate.window!.rootViewController
        let mainstoryboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
        let centerViewController = mainstoryboard.instantiateViewController(withIdentifier: "HomeTableViewController") as! HomeTableViewController
        let leftViewController = mainstoryboard.instantiateViewController(withIdentifier: "MenuTableViewController") as! MenuTableViewController
        let leftsideNav = UINavigationController(rootViewController: leftViewController)
        let centerNav = UINavigationController(rootViewController: centerViewController)
        
        let centerContainer: MMDrawerController = MMDrawerController(center: centerNav, leftDrawerViewController: leftsideNav)
        centerContainer.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView;
        centerContainer.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView;
    
        appdelegate.centerContainer = centerContainer
        appdelegate.window!.rootViewController = centerContainer
        appdelegate.window!.makeKeyAndVisible()
        
        
    }

}
