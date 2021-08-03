//
//  Persistence.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 3/28/21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    static var preview: PersistenceController = {
        
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
                
//        // Create some preview items
//        let trip1 = Trip(context: viewContext)
//        trip1.date = Date()
//        trip1.destination = "Preview Resort, TX"
//        trip1.imageName = "None"
//
//        let trip2 = Trip(context: viewContext)
//        trip2.date = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
//        trip2.destination = "Previous Resort, TX"
//        trip2.imageName = "None"
//
//        let item1 = ChecklistItem(context: viewContext)
//        item1.title = "TODO: 1"
//        item1.instructions = "Do whatever is needed"
//        item1.imageName = "testImage"
//        item1.category = "Pretrip"
//        item1.sequence = 1
//
//        let item2 = ChecklistItem(context: viewContext)
//        item2.title = "TODO: 2"
//        item2.instructions = "Do whatever is needed for item 2"
//        item2.imageName = "testImage"
//        item2.category = "Pretrip"
//        item2.sequence = 2
//
//        let item3 = ChecklistItem(context: viewContext)
//        item3.title = "TODO: 3"
//        item3.instructions = "Item 3 instructions"
//        item3.imageName = "testImage"
//        item3.category = "Pretrip"
//        item3.sequence = 3
//
//        do {
//            try viewContext.save()
//        } catch {
//            let nsError = error as NSError
//            print("Error saving preview trips: \(nsError), \(nsError.userInfo)")
//        }

        // Load all checklist items from json
        do {
            _ = try reloadChecklist(context: viewContext)
        } catch {
            let nsError = error as NSError
            print("Error loading preview checklist: \(nsError), \(nsError.userInfo)")
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error saving preview checklist: \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "RvChecklistCDi")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    static func deleteChecklist(context: NSManagedObjectContext) {

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ChecklistItem")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let container = PersistenceController.shared.container

        do {
            try container.persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch {
            print("Error deleting checklist items")
        }
        do {
            try container.viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error saving deleted checklist: \(nsError), \(nsError.userInfo)")
        }
    }
    
    // Reload checklist from a json file.
    @discardableResult
    static func reloadChecklist(context: NSManagedObjectContext) throws -> [ChecklistItem] {

        // First, delete all existing checklist entities
        deleteChecklist(context: context)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context

        return try load("checklistData.json", decoder: decoder)
    }

    static func load<T: Decodable>(_ filename: String, decoder: JSONDecoder) throws -> T {

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            throw DecoderConfigurationError.missingJSONfile
        }

        let data = try Data(contentsOf: file)

        return try decoder.decode(T.self, from: data)
    }

}

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
    case missingJSONfile
}

