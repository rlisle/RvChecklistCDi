//
//  Trip+CoreDataProperties.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 3/28/21.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var date: Date?
    @NSManaged public var destination: String?
    @NSManaged public var imageName: String?

}

extension Trip : Identifiable {

}
