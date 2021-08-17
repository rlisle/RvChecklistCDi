//
//  DeleteItem.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 8/17/21.
//

import SwiftUI

struct DeleteItem: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var item: ChecklistItem
    
    @State private var title = "New TODO:"
    @State private var instructions = "Instructions..."
    @State private var category = "Pre-Trip"

    var body: some View {
        VStack {
            Text("Delete this item?")
                .bold()
            
            Form {
                Section(header: Text("Title")) {
                    Text(title)
                }
                Section(header: Text("Category")) {
                    Text(category)
                }
                Section(header: Text("Instructions")) {
                    Text(instructions)
                }
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            deleteItem()
                            self.presentationMode.wrappedValue.dismiss()
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Delete Item")
                        }
                        Spacer()
                    }
                    .padding(10)
                }
            }//Form
        }//VStack
        .background(Color(red: 32/255, green: 32/255, blue: 32/255))
        .edgesIgnoringSafeArea(.all)
        .blackNavigation
        .navigationBarTitle("Delete Item", displayMode: .inline)
        
        .onAppear() {
            title = item.wrappedTitle
            instructions = item.wrappedInstructions
            category = item.wrappedCategory
        }
    }

    private func deleteItem() {
        viewContext.delete(item)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error saving deleted item: \(nsError), \(nsError.userInfo)")
        }
    }
}

struct DeleteItemPreviewContainer: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        let persistenceController = PersistenceController.shared
        let context = persistenceController.container.viewContext
        DeleteItem(item: ChecklistItem(
                    context: context,
                    title: "TODO Item",
                    instructions: "Do whatever is needed",
                    photo: UIImage(systemName: "photo")!,
                    sequence: 1,
                    category: "Pre-Trip"))
    }
    
    public init() { }
}

struct DeleteItem_Previews: PreviewProvider {
    static var previews: some View {
        DeleteItemPreviewContainer()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
