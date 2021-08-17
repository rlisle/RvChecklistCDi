//
//  EditItem.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 4/20/21.
//

import SwiftUI

struct EditItem: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var item: ChecklistItem
    
    @State private var title = "New TODO:"
    @State private var instructions = "Instructions..."
    @State private var category = "Pre-Trip"

    @State private var originalTitle = "New TODO:"
    @State private var originalInstructions = "Instructions..."
    @State private var originalCategory = "Pre-Trip"

    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Title", text: $title)
            }
            Section(header: Text("Category")) {
                TextField("Pre-Trip", text: $category)
            }
            Section(header: Text("Instructions")) {
                TextField("Instructions", text: $instructions)
            }
            Section {
                HStack {
                    Spacer()
                    Button(action: {
                        updateItemEntities()    // Is this necessary?
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Update Item")
                    }
                    .disabled(title.isEmpty)
                    Button(action: {
                        // Undo any changes
                        title = originalTitle
                        instructions = originalInstructions
                        category = originalCategory
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                    }
                    Spacer()
                }
                .padding(10)
            }
        }
        .background(Color(red: 32/255, green: 32/255, blue: 32/255))
        .edgesIgnoringSafeArea(.all)
        .blackNavigation
        .navigationBarTitle("Edit Trip", displayMode: .inline)
        
//        .onAppear() {
//            title = item.wrappedTitle
//            originalTitle = title
//            instructions = item.wrappedInstructions
//            originalInstructions = instructions
//            category = item.wrappedCategory
//            originalCategory = category
//        }
    }
    
    public init(item: ChecklistItem) {
        self.item = item
        title = item.wrappedTitle
        originalTitle = title
        instructions = item.wrappedInstructions
        originalInstructions = instructions
        category = item.wrappedCategory
        originalCategory = category
    }

    private func updateItemEntities() {
        item.title = title
        item.instructions = instructions
        try? viewContext.save()
    }
}

struct EditItemPreviewContainer: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        let persistenceController = PersistenceController.shared
        let context = persistenceController.container.viewContext
        EditItem(item: ChecklistItem(
                    context: context,
                    title: "TODO Item",
                    instructions: "Do whatever is needed",
                    photo: UIImage(systemName: "photo")!,
                    sequence: 1,
                    category: "Pre-Trip"))
    }
    
    public init() { }
}

struct EditItem_Previews: PreviewProvider {
    static var previews: some View {
        EditItemPreviewContainer()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
