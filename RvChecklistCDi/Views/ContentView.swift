//
//  ContentView.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 3/28/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State var selectedTrip: Trip?
    @State private var showCompleted = false
    @State var showMenu = false
    @State private var menuSelection: String? = nil

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.date, ascending: false)],
        animation: .default)
    private var trips: FetchedResults<Trip>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ChecklistItem.sequence, ascending: true)])
    private var items: FetchedResults<ChecklistItem>
    
    var body: some View {
        
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            }
        
        
        return NavigationView {

            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    VStack {
                        Group {
                            // Side menu selected destinations
                            NavigationLink(destination: AddTrip(selectedTrip: $selectedTrip), tag: "Add",
                                           selection: $menuSelection,
                                           label: { EmptyView() })
                            NavigationLink(destination: EditTrip(trip: $selectedTrip),
                                           tag: "Edit",
                                           selection: $menuSelection,
                                           label: { EmptyView() })
                        }
                        
                        // TODO: Shrink header when scrolling
                        HeaderView()
                        // Maybe user LazyVStack instead?
                        List {
                            TripSection(selectedTrip: $selectedTrip)
                            
                            ChecklistSection(name: "Pre-Trip",
                                             heading: sectionText("Pre-Trip"),
                                             showCompleted: showCompleted,
                                             items: items)
                            
                            ChecklistSection(name: "Departure",
                                             heading: sectionText("Departure"),
                                             showCompleted: showCompleted,
                                             items: items)
                            
                            ChecklistSection(name: "Arrival",
                                             heading: sectionText("Arrival"),
                                             showCompleted: showCompleted,
                                             items: items)
                            
                        }
                        .listStyle(GroupedListStyle())
                        .animation(.easeInOut)
                        .overlay(items.isEmpty ? Text("Create a trip first") : nil, alignment: .center)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: self.showMenu ? geometry.size.width/2 : 0)
                    .disabled(self.showMenu ? true : false)
                
                    if self.showMenu {
                        MenuView(showMenu: $showMenu,
                                 showCompleted: $showCompleted,
                                 selection: $menuSelection,
                                 selectedTrip: selectedTrip)
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .leading))
                    }

                }
                .gesture(drag)
                .blackNavigation
                .navigationBarTitle("RV Checklist", displayMode: .inline)
                .navigationBarItems(leading: (
                    Button(action: {
                        withAnimation {
                            self.showMenu.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                    }
                ))
            }
        }
        .accentColor( .black)   // Sets back button color
        .onAppear {
            //TODO: maybe run instead when trips change?
            selectedTrip = nextTrip()
        }
    }
    
//    private func done(_ list: [ChecklistItem]) -> [ChecklistItem] {
//        return list.filter { $0.isDone == true }
//    }
//
//    private func todo(_ list: [ChecklistItem]) -> [ChecklistItem] {
//        return list.filter { $0.isDone == false }
//    }

    private func sectionText(_ section: String) -> Text {
        let doneCount = items.filter { $0.category == section && $0.isDone == true }.count
        let sectionCount = items.filter {
            $0.category == section
        }.count

        return Text("\(section) (\(doneCount) of \(sectionCount) items done)")
    }
    
    private func nextTrip() -> Trip? {
        var upcoming: Trip? = nil
        let today = Date()  //TODO: set to today's date at 00:00.000
        print("Calculating next trip. Today is \(today)")
        for trip in trips {
            if(trip.wrappedDate >= today && (upcoming == nil || trip.wrappedDate < upcoming!.wrappedDate)) {
                print("Selecting \(trip.wrappedDestination)")
                upcoming = trip
            }
        }
        // If there are no upcoming trips, then select the last trip
        if(upcoming == nil) {
            print("No upcoming trips, selecting last")
            upcoming = trips.last
        }
        return upcoming
    }
    
//    private func clearChecklist() {
//        do {
//            try PersistenceController.reloadChecklist(context: viewContext)
//            try viewContext.save()
//        } catch {
//            print("Error clearing checklist")
//        }
//    }
    
    init() {
        UINavigationBarAppearance().configureWithTransparentBackground()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
