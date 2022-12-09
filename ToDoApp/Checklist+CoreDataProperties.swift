//
//  Checklist+CoreDataProperties.swift
//  ToDoApp
//
//  Created by S I on 12/9/22.
//
//

import Foundation
import CoreData


extension Checklist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Checklist> {
        return NSFetchRequest<Checklist>(entityName: "Checklist")
    }

    @NSManaged public var name: String
    @NSManaged public var listIconName: String
    @NSManaged public var listOfItems: NSSet

}

// MARK: Generated accessors for listOfItems
extension Checklist {

    @objc(addListOfItemsObject:)
    @NSManaged public func addToListOfItems(_ value: ChecklistItem)

    @objc(removeListOfItemsObject:)
    @NSManaged public func removeFromListOfItems(_ value: ChecklistItem)

    @objc(addListOfItems:)
    @NSManaged public func addToListOfItems(_ values: NSSet)

    @objc(removeListOfItems:)
    @NSManaged public func removeFromListOfItems(_ values: NSSet)

}

extension Checklist : Identifiable {

}
