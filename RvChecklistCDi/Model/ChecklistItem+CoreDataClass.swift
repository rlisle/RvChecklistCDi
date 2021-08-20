//
//  ChecklistItem+CoreDataClass.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 3/28/21.
//
//

import UIKit
import CoreData

@objc(ChecklistItem)
public class ChecklistItem: NSManagedObject, Decodable {

    enum CodingKeys: CodingKey {
        case title
        case instructions
        case photoData
        case sequence
        case category
        case timestamp
        case isDone
    }

    public override var debugDescription: String {
        "\(category ?? "No category").\(sequence): \(title ?? "No title"), \(isDone ? "Done" : "Undone")"
    }

    public override var description: String {
        "\(category ?? "No category").\(sequence): \(title ?? "No title"), \(isDone ? "Done" : "Undone")"
    }

    required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.instructions = try container.decode(String.self, forKey: .instructions)
        self.photoData = try container.decodeIfPresent(Data.self, forKey: .photoData)
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
    
    public var wrappedPhoto: UIImage {
        guard let photoData = photoData,
            let image = UIImage(data: photoData) else {
            return UIImage(named: "AppIcon")!
        }
        return image
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
                       photo: UIImage,
                       sequence: Int16,
                       category: String
    ) {
        let item = ChecklistItem(context: context)
        item.title = title
        item.instructions = instructions
        item.photoData = photo.pngData()
        item.sequence = sequence
        item.category = category
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Error saving inserted item: \(nsError), \(nsError.userInfo)")
        }
    }
    
    convenience init(context: NSManagedObjectContext, title: String, instructions: String, photo: UIImage, sequence: Int, category: String) {
        self.init(context: context)
        self.title = title
        self.instructions = instructions
        self.photoData = photo.pngData()
        self.sequence = Int16(sequence)
        self.category = category
    }
}
