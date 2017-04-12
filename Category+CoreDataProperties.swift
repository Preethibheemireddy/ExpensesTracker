//
//  Category+CoreDataProperties.swift
//  Expenses Tracker
//
//  Created by Preethi Bheemireddy on 3/21/17.
//  Copyright © 2017 Preethi Bheemireddy. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category");
    }

    @NSManaged public var category: String?
    @NSManaged public var categorytoexpense: NSSet?
    @NSManaged public var register: Register?

}

// MARK: Generated accessors for categorytoexpense
extension Category {

    @objc(addCategorytoexpenseObject:)
    @NSManaged public func addToCategorytoexpense(_ value: Expenses)

    @objc(removeCategorytoexpenseObject:)
    @NSManaged public func removeFromCategorytoexpense(_ value: Expenses)

    @objc(addCategorytoexpense:)
    @NSManaged public func addToCategorytoexpense(_ values: NSSet)

    @objc(removeCategorytoexpense:)
    @NSManaged public func removeFromCategorytoexpense(_ values: NSSet)

}
