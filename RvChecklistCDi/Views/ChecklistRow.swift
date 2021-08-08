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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ChecklistItem.sequence, ascending: true)])
    private var items: FetchedResults<ChecklistItem>

     var body: some View {
        ChecklistRow(item: items.first!)
     }
}

struct ChecklistRow_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistRowPreviewContainer()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .previewLayout(.fixed(width: 320, height: 40))
        .previewDisplayName("Checkmark")
    }
}
