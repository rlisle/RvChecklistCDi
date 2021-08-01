//
//  TripRow.swift
//  RvChecklistCDi
//
//  Displays a trip in the TripHistory.
//  Tapping it sets the selectedTrip and returns.
//
//  Created by Ron Lisle on 3/30/21.
//

import SwiftUI

struct TripRow: View {
    
    @State var trip: Trip?

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    var body: some View {
//        NavigationLink(
//            destination: EditTrip(trip: $trip)) {
            HStack {
                Text(trip?.wrappedDestination ?? "New Trip")
                Spacer()
                Text(dateFormatter.string(from: trip?.wrappedDate ?? Date()))
            }
//        }
    }
}

struct TripRow_Previews: PreviewProvider {
    static var previews: some View {
        let trip = Trip(context: PersistenceController.preview.container.viewContext)
        TripRow(trip: trip)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewLayout(.fixed(width: 300, height: 40))
            .previewDisplayName("Trip")
    }
}
