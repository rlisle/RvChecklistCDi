//
//  EditTrip.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 4/20/21.
//

import SwiftUI

struct EditTrip: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var trip: Trip?
    
    @State private var destination = ""
    @State private var date = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
//    @State var lengthOfStay: Int
//    @State var coordinate: CLLocationCoordinate2D
    
    var body: some View {
        // trip should never be nil, but just in case
        if trip == nil {
            Text("No trip selected")
        } else {
            Form {
                Section(header: Text("Destination")) {
                    TextField("Destination", text: $destination)
                }
                Section {
                    DatePicker(
                        selection: $date,
                        displayedComponents: .date) { Text("Date").foregroundColor(Color(.gray)) }
                }
                //TODO: Coordinate?
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            updateTripEntities()
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Update Trip")
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
            .background(Color(red: 32/255, green: 32/255, blue: 32/255))
            .edgesIgnoringSafeArea(.all)
            .blackNavigation
            .navigationBarTitle("Edit Trip", displayMode: .inline)
            
            .onAppear() {
                destination = trip!.wrappedDestination
                date = trip!.wrappedDate
            }
        }
    }

    private func updateTripEntities() {
        trip!.destination = destination
        trip!.date = date
        try? viewContext.save()
    }
}

struct EditTripPreviewContainer: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var trip: Trip?

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.date, ascending: false)],
        animation: .default)
    private var trips: FetchedResults<Trip>

    var body: some View {
        EditTrip(trip: $trip)
    }
    
    init() {
        print("trip = \(trips)")
    }
}

struct EditTrip_Previews: PreviewProvider {
    static var previews: some View {
        EditTripPreviewContainer()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
