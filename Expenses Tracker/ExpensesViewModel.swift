//
//  ExpensesViewModel.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 4/17/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//

import Foundation
import CoreData

class ExpensesViewModel {
    
    var Expensedata: Expenses? = nil
    var data: [String] = ["Groceries", "Shopping", "Restaurants"]
    var numberFormatter = NumberFormatter()
    var isConversionSuccessful: Bool = false
    var isEdited = false
    
}
