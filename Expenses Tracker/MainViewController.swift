//
//  MainViewController.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 3/8/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    
    @IBOutlet weak var backgroundimage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        backgroundimage.image = UIImage(named: "expense.jpg")
        let rect = AVMakeRect(aspectRatio: (backgroundimage.image?.size)!, insideRect: backgroundimage.bounds)
        backgroundimage.image?.draw(in: rect)
        
        self.navigationController?.toolbar.isHidden = false
       
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
