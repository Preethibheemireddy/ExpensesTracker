//
//  CategoryTableViewController.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 3/8/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController   {
    
    var categories: [Category] = []
    
    
    @IBOutlet weak var Tableview: UITableView!
    override func viewDidLoad() {
        
        Tableview.estimatedRowHeight = 44.0;
        Tableview.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBar.barTintColor = UIColor.brown
        
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkCategory()
        
        Tableview.reloadData()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    @IBAction func Homebutton(_ sender: Any) {
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    @IBAction func Add(_ sender: Any) {
        
        
        performSegue(withIdentifier: "addcategory", sender: self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categorycell", for: indexPath)
        
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.category
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // cell to be deleted is selected indexpath.row
            let deletedCategory = categories[indexPath.row]
            // To delete category from database
            databaseModel.context.delete(deletedCategory as NSManagedObject)
            // save database
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            // remove deleted category from categories array
            categories.remove(at: indexPath.row)
            tableView.beginUpdates()
            // delete table view cell
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            Tableview.reloadData()
            
            
            
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "editcategory" {
            
            let indexpath = Tableview.indexPathForSelectedRow!
            print(indexpath)
            let item: AddCategoryViewController  = segue.destination as! AddCategoryViewController
            let newtask: Category = categories[indexpath.row]
            item.categorymodel.categorydata = newtask
            
            
            
        }
        
        
        
    }
    
    
}
