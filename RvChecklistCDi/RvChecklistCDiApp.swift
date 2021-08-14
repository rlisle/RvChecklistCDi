//
//  RvChecklistCDiApp.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 8/1/21.
//

import SwiftUI

@main
struct RvChecklistCDiApp: App {
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView2()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
