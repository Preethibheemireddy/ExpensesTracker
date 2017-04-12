//
//  dateDisplay.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 4/5/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//

import Foundation

class dateDisplay {
    
  public static  var dateFormatter = DateFormatter()
    
    public static func formatDate() {
       
        dateFormatter.dateStyle = DateFormatter.Style.medium
       dateFormatter.timeStyle = DateFormatter.Style.none
        
    }
    
}
