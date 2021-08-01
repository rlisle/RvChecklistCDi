//
//  AddTrip.swift
//  RvChecklist
//
//  Created by Ron Lisle on 3/13/21.
//

import SwiftUI
import MapKit

struct AddTrip: View {
    static let DefaultDestination = "New Trip"

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ChecklistItem.sequence, ascending: true)])
    private var checklistItems: FetchedResults<ChecklistItem>

    @Binding var selectedTrip: Trip?
    
    @State private var destination = ""
    @State private var date = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
//    @State var lengthOfStay: Int
//    @State var coordinate: CLLocationCoordinate2D
    
    var body: some View {
        Form {
            Section(header: Text("Destination")) {
                TextField("Destination", text: $destination)
            }
            Section {
                DatePicker(
                    selection: $date,
                    displayedComponents: .date) { Text("Date").foregroundColor(Color(.gray)) }
            }
//                Section(header: Text("Length of Stay")) {
//                    TextField("Length of Stay", text: $lengthOfStay)
//                }
            //TODO: Coordinate?
            Section {
                HStack {
                    Spacer()
                    Button(action: {
                        if destination.isEmpty { destination = AddTrip.DefaultDestination
                        }
                        createTripEntities()
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Add Trip")
                    }
                    .disabled(destination.isEmpty)
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

    private func createTripEntities() {
        selectedTrip = Trip.insert(
            in: viewContext,
            destination: destination,
            imageName: "None",
            date: date)
        try? viewContext.save()
        
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
        AddTrip(selectedTrip: .constant(nil))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
