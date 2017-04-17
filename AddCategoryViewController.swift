//
//  AddCategoryViewController.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 3/8/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//

import UIKit
import CoreData


class AddCategoryViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var categorymodel = AddCategoryModel()
    @IBOutlet weak var category: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddCategoryViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        
        if categorymodel.categorydata != nil {
            
            categoryText.text = categorymodel.categorydata?.category
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBOutlet weak var categoryText: UITextField!
    
    @IBAction func Savecategory(_ sender: Any) {
        
        createCategory()
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        self.performSegue(withIdentifier: "savecategory", sender: self)
        
    }
    
    func createCategory() {
        
        if(categorymodel.categorydata != nil) {
            //update core data
            //check if category already exists
            categorymodel.isSuccessful = saveexpense()
            
            // if category doesn't exist in database update category with new category
            if (categorymodel.isSuccessful == true) {
                categorymodel.categorydata?.category = categoryText.text!
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
                // display alert if category already exists in database
            else{
                alertDisplay.displayalert(usermessage: "Category already exists", view: self)
                
            }
        }
            // To save category
        else if (categoryText.text != "") {
            //save to core data
            
            // check if category already exists
            categorymodel.isSuccessful = saveexpense()
            // // if category doesn't exist in database create new category
            if (categorymodel.isSuccessful == true) {
                for object in categorymodel.result {
                    let categoryData = Category(context: databaseModel.context)
                    categoryData.register?.email = object.email
                    object.addToCategory(categoryData)
                    categoryData.category = categoryText.text
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
                
            }
                // display alert if category already exists in database
            else{
                alertDisplay.displayalert(usermessage: "Category already exists", view: self)
                
            }
            
        }
            // display alert if category text is nil
        else{
            alertDisplay.displayalert(usermessage: "Enter Category to save", view: self)
            
        }
        
    }
    
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "savecategory", sender: self)
        
    }
    
    
    
    func saveexpense()  -> Bool {
        var checkcategory: Bool = false
        // To sort Register database with lastname
        let sort = NSSortDescriptor(key: "lastname", ascending: true)
        // To predicate the data using email ID
        let predicate = NSPredicate(format: "email = %@", userloggedin.userEmail!)
        //To check if database contains user entered category
        databaseModel.fetchRegister.predicate = predicate
        databaseModel.fetchRegister.sortDescriptors = [sort]
        do {
            categorymodel.result = try databaseModel.context.fetch(databaseModel.fetchRegister)
            if (categorymodel.result.count > 0) {
                for object in categorymodel.result {
                    categorymodel.categoryobject = ((object.category?.allObjects)! as! [Category])
                    
                    for data in categorymodel.categoryobject {
                        if((data.category?.lowercased()) == (categoryText.text?.lowercased())) {
                            
                            checkcategory = false
                            return checkcategory
                        }
                        
                        
                    }
                    checkcategory = true
                }
                
            }
            else{
                print("error")
            }
        } catch {
            print("Fetching Failed")
            
        }
        return checkcategory
    }
    
    
    
}


