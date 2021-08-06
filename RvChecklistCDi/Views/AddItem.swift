//
//  AddItem.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 3/13/21.
//

import SwiftUI

struct AddItem: View {
    let defaultTitle = "New TODO"

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ChecklistItem.sequence, ascending: true)])
    private var checklistItems: FetchedResults<ChecklistItem>

    @State private var title = ""
    @State private var date = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
    @State private var instructions = ""
    @State private var photo = UIImage()
    @State private var sequence = 0
    @State private var category = "Pretrip"
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    Button(action: {
                        if title.isEmpty { title = defaultTitle
                        }
                        createItemEntities()
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Add Item")
                    }
                    .disabled(title.isEmpty)
                    Spacer()
                }
                .padding(10)
                .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                )
            }
        }
        .blackNavigation
        .navigationBarTitle("", displayMode: .inline)
    }

    private func createItemEntities() {
        ChecklistItem.insert(
            in: viewContext,
            title: title,
            instructions: instructions,
            photo: photo,
            sequence: Int16(sequence),
            category: category
            )
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error saving created item entities: \(nsError), \(nsError.userInfo)")
        }
        
        do {
            try PersistenceController.reloadChecklist(context: viewContext)
            try viewContext.save()
        } catch {
            print("Error reloading new trip checklist")
        }
    }
}

struct AddTrip_Previews: PreviewProvider {
    static var previews: some View {
        AddItem()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
