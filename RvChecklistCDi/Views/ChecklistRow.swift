//
//  ChecklistRow.swift
//  RvChecklist
//
//  Created by Ron Lisle on 3/24/21.
//

import SwiftUI

struct ChecklistRow: View {

    @ObservedObject var item: ChecklistItem
    
    var body: some View {
        HStack {
            Text(item.wrappedTitle).strikethrough(item.isDone)
            Spacer()
            Checkmark(isDone: $item.isDone)
        }
    }
    
}

struct ChecklistRowPreviewContainer : View {

    @StateObject var item = ChecklistItem(context: PersistenceController.preview.container.viewContext,
                                     title: "Test TODO Item",
                                     instructions: "Steps 1, 2, 3...",
                                     photo: UIImage(systemName: "photo")!,
                                     sequence: 1,
                                     category: "Pre-Trip")

     var body: some View {
        ChecklistRow(item: item)
     }
}

struct ChecklistRow_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistRowPreviewContainer()
//        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//        ChecklistRow(item: ChecklistItem(context: PersistenceController.preview.container.viewContext,
//                                         title: "Test TODO Item",
//                                         instructions: "Steps 1, 2, 3...",
//                                         photo: UIImage(systemName: "photo")!,
//                                         sequence: 1,
//                                         category: "Pre-Trip"))
        .previewLayout(.fixed(width: 320, height: 40))
        .previewDisplayName("ChecklistRow")
    }
}
