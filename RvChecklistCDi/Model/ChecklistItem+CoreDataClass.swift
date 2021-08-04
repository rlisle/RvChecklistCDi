//
//  ChecklistItem+CoreDataClass.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 3/28/21.
//
//

import Foundation
import CoreData

@objc(ChecklistItem)
public class ChecklistItem: NSManagedObject, Decodable {

    enum CodingKeys: CodingKey {
        case title
        case instructions
        case imageName
        case sequence
        case category
        case timestamp
        case isDone
    }

    required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.instructions = try container.decode(String.self, forKey: .instructions)
        self.imageName = try container.decode(String.self, forKey: .imageName)
        self.sequence = try container.decode(Int16.self, forKey: .sequence)
        self.category = try container.decode(String.self, forKey: .category)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
        self.isDone = try container.decode(Bool.self, forKey: .isDone)
    }
    
    public var wrappedTitle: String {
        title ?? "To Do:"
    }
    
    public var wrappedInstructions: String {
        instructions ?? "Steps to accomplish TODO:..."
    }
    
    public var wrappedImageName: String {
        imageName ?? "No Image"
    }
    
    public var wrappedCategory: String {
        category ?? "Pre-Trip"
    }
    
    public var wrappedTimestamp: Date {
        timestamp ?? Date()
    }
    
    static func insert(in context: NSManagedObjectContext,
                       title: String,
                       instructions: String,
                       imageName: String,
                       sequence: Int16,
                       category: String
    ) {
        let item = ChecklistItem(context: context)
        item.title = title
        item.instructions = instructions
        item.imageName = imageName
        item.sequence = sequence
        item.category = category
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Error saving inserted item: \(nsError), \(nsError.userInfo)")
        }
    }
    
    convenience init(context: NSManagedObjectContext, title: String, instructions: String, imageName: String, sequence: Int, category: String) {
        self.init(context: context)
        self.title = title
        self.instructions = instructions
        self.imageName = imageName
        self.sequence = Int16(sequence)
        self.category = category
    }
}
