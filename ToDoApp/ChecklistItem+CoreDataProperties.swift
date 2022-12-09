//
//  ChecklistItem+CoreDataProperties.swift
//  ToDoApp
//
//  Created by S I on 12/7/22.
//
//

import Foundation
import CoreData


extension ChecklistItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChecklistItem> {
        return NSFetchRequest<ChecklistItem>(entityName: "ChecklistItem")
    }

    @NSManaged public var title: String
    @NSManaged public var itemDescription: String
    @NSManaged public var category: String
    @NSManaged public var checked: Int16

}

extension ChecklistItem : Identifiable {

}
