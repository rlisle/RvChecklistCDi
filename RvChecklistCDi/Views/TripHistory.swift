//
//  TripHistory.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 3/30/21.
//

import SwiftUI

struct TripHistory: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext

    @Binding var selectedTrip: Trip?

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.date, ascending: false)],
        animation: .default)
    private var trips: FetchedResults<Trip>

    //TODO: group stops within each trip
    var body: some View {
            List(trips, id:\.self, selection: $selectedTrip) { trip in
                Button(action: {
                    selectedTrip = trip
                    presentationMode.wrappedValue.dismiss()
                }) {
                    TripRow(trip: trip)
                }
            }
            .blackNavigation
            .navigationBarTitle("Trip History", displayMode: .inline)
            //.navigationBarBackButtonHidden(true)
            //.navigationBarItems(leading: btnBack)
            .navigationBarItems(trailing: (
                NavigationLink(
                    destination: AddTrip(selectedTrip: $selectedTrip)) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            ))

            .toolbar {
                EditButton()
            }
            .animation(.easeInOut)
    }
    
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { trips[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

struct TripHistory_Previews: PreviewProvider {
    static var previews: some View {
        TripHistory(selectedTrip: .constant(nil))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
