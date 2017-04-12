//
//  Expenses+CoreDataProperties.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 3/21/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//

import Foundation
import CoreData


extension Expenses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expenses> {
        return NSFetchRequest<Expenses>(entityName: "Expenses");
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var details: String?
    @NSManaged public var expensetocategory: Category?
    @NSManaged public var register: Register?

}
