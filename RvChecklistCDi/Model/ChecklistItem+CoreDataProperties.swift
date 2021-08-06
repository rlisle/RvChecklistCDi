//
//  ChecklistItem+CoreDataProperties.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 3/28/21.
//
//

import UIKit
import CoreData


extension ChecklistItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChecklistItem> {
        return NSFetchRequest<ChecklistItem>(entityName: "ChecklistItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var instructions: String?
    @NSManaged public var photo: UIImage?
    @NSManaged public var sequence: Int16
    @NSManaged public var category: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var isDone: Bool

}

extension ChecklistItem : Identifiable {

}
