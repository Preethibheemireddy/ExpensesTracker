//
//  alertDisplay.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 4/5/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//

import Foundation

class alertDisplay {
    
   public static func displayalert(usermessage: String, view: UIViewController) {
        
        let alert = UIAlertController(title: "alert", message: usermessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(action);
        
        
        view.present(alert, animated: true, completion: nil);
    }

}
