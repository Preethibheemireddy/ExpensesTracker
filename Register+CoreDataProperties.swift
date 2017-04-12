//
//  Register+CoreDataProperties.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 3/21/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//

import Foundation
import CoreData


extension Register {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Register> {
        return NSFetchRequest<Register>(entityName: "Register");
    }

    @NSManaged public var confirmPassword: String?
    @NSManaged public var email: String?
    @NSManaged public var firstname: String?
    @NSManaged public var lastname: String?
    @NSManaged public var password: String?
    @NSManaged public var expense: NSSet?
    @NSManaged public var category: NSSet?

}

// MARK: Generated accessors for expense
extension Register {

    @objc(addExpenseObject:)
    @NSManaged public func addToExpense(_ value: Expenses)

    @objc(removeExpenseObject:)
    @NSManaged public func removeFromExpense(_ value: Expenses)

    @objc(addExpense:)
    @NSManaged public func addToExpense(_ values: NSSet)

    @objc(removeExpense:)
    @NSManaged public func removeFromExpense(_ values: NSSet)

}

// MARK: Generated accessors for category
extension Register {

    @objc(addCategoryObject:)
    @NSManaged public func addToCategory(_ value: Category)

    @objc(removeCategoryObject:)
    @NSManaged public func removeFromCategory(_ value: Category)

    @objc(addCategory:)
    @NSManaged public func addToCategory(_ values: NSSet)

    @objc(removeCategory:)
    @NSManaged public func removeFromCategory(_ values: NSSet)

}
