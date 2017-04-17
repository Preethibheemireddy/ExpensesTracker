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
    
    public var loggedin: Bool = false
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UITextField!
    let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Login(_ sender: Any) {
        
        
        if (login.text != "" && password.text != "") {
            let login = checkEmail()
            if (login == true) {
                userloggedin.userEmail = self.login.text
                
                self.performSegue(withIdentifier: "Loggedin", sender: self)
                
                slidemenu()
                
                
            }
            
        }
        else{
            alertDisplay.displayalert(usermessage: "All fields are required", view: self)
            
        }
        
    }
    
    func checkEmail() -> Bool {
        var LoginSuccess: Bool = false
        let sort = NSSortDescriptor(key: "lastname", ascending: true)
        let predicate = NSPredicate(format: "email = %@", login.text!)
        //To check if database contains user entered value
        databaseModel.fetchRegister.predicate = predicate
        databaseModel.fetchRegister.sortDescriptors = [sort]
        do {
            let result = try databaseModel.context.fetch(databaseModel.fetchRegister)
            print(result.count)
            if (result.count > 0) {
                for object in result {
                    if (password.text != object.password) {
                        alertDisplay.displayalert(usermessage: "Email/Password does not match", view: self)
                        return LoginSuccess
                    }
                    LoginSuccess = true
                    
                }
                
            }
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
        
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        appdelegate.centerContainer = centerContainer
        appdelegate.window!.rootViewController = centerContainer
        appdelegate.window!.makeKeyAndVisible()
        
        
    }

}
