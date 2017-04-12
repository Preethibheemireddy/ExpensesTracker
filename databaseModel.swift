//
//  databaseModel.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 4/11/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//

import Foundation
import  CoreData

class databaseModel {
    
    public static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   public static var fetchRegister:NSFetchRequest<Register> = Register.fetchRequest()
   public static var fetchExpenses:NSFetchRequest<Expenses> = Expenses.fetchRequest()
   public static var fetchCategory:NSFetchRequest<Category> = Category.fetchRequest()
}
