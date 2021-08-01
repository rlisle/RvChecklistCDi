//
//  TripSection.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 3/29/21.
//

import SwiftUI

struct TripSection: View {

//    @Environment(\.managedObjectContext) private var viewContext

    @Binding var selectedTrip: Trip?
    
    var body: some View {
        
        Section(header: Text("Trip")) {
            NavigationLink(destination: TripHistory(selectedTrip: $selectedTrip)) {
                Text(selectedTrip?.wrappedDestination ?? "New Trip")
            }
        }
    }
}

struct TripSection_Previews: PreviewProvider {
    static var previews: some View {
        TripSection(selectedTrip: .constant(nil))
    }
}

//struct TripSectionPreviewContainer: View {
//
//    @State private var trip = Trip()
//
//    var body: some View {
//        TripSection(selectedTrip: $trip)
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//
//}
//
//struct TripSection_Previews: PreviewProvider {
//    static var previews: some View {
//        EditTripPreviewContainer()
//    }
//}
