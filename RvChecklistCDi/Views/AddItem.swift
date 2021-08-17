//
//  AddItem.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 3/13/21.
//

import SwiftUI

struct AddItem: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var title = "New TODO:"
    @State private var instructions = "Instructions..."
    @State private var category = "Pre-Trip"
    
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
                        createChecklistItem()
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Add Item")
                    }
                    .disabled(title.isEmpty)
                    Button(action: {
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
        .navigationBarTitle("Add Item", displayMode: .inline)
    }

    private func createChecklistItem() {
        ChecklistItem.insert(
            in: viewContext,
            title: title,
            instructions: instructions,
            photo: UIImage(systemName: "photo")!,
            sequence: Int16(1),
            category: category
            )
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error saving created item entities: \(nsError), \(nsError.userInfo)")
        }
    }
}

struct AddTrip_Previews: PreviewProvider {
    static var previews: some View {
        AddItem()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
