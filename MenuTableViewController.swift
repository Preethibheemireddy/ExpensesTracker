//
//  MenuTableViewController.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 3/8/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
   


    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.brown
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Homebutton(_ sender: Any) {
        
        let centerview = self.storyboard?.instantiateViewController(withIdentifier: "HomeTableViewController") as! HomeTableViewController
        
        let centerNav = UINavigationController(rootViewController: centerview)
        let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.centerContainer!.centerViewController = centerNav
        appdelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
        
    }
    
    
    @IBAction func Category(_ sender: Any) {
        
        let Aboutview = self.storyboard?.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        
        let AboutNav = UINavigationController(rootViewController: Aboutview)
        let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.centerContainer!.centerViewController = AboutNav
        appdelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
        
    }

    @IBAction func Logout(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.setValue(nil, forKey: "userEmail")
        UserDefaults.standard.synchronize()
        
        let centerview = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let centerNav = UINavigationController(rootViewController: centerview)
        
        appdelegate.window?.rootViewController = centerNav
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
   
}
