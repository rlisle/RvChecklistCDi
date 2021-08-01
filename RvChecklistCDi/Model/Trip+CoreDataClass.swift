//
//  Trip+CoreDataClass.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 3/28/21.
//
//

import Foundation
import CoreData

@objc(Trip)
public class Trip: NSManagedObject {

    public var wrappedDestination: String {
        destination ?? "New Trip"
    }
    
    public var wrappedImageName: String {
        imageName ?? "no image"
    }
    
    public var wrappedDate: Date {
        date ?? Date()
    }
    
    @discardableResult
    static func insert(in context: NSManagedObjectContext,
                       destination: String,
                       imageName: String,
                       date: Date) -> Trip {
        let trip = Trip(context: context)
        trip.destination = destination
        trip.imageName = imageName
        trip.date = date
        // Should we save here or assume caller saves?
        return trip
    }
}
