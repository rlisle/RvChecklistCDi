//
//  ContentView2.swift
//  ContentView2
//
//  Created by Ron Lisle on 8/13/21.
//

import SwiftUI
import CoreData

struct ContentView2: View {
    
    @State private var menuSelection: String? = nil

    @FetchRequest(
        entity: ChecklistItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ChecklistItem.sequence, ascending: true)],
        predicate: NSPredicate(format: "category == %@", "Pre-Trip")
        )
    private var preTripItems: FetchedResults<ChecklistItem>

    @FetchRequest(
        entity: ChecklistItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ChecklistItem.sequence, ascending: true)],
        predicate: NSPredicate(format: "category == %@", "Departure")
        )
    private var departItems: FetchedResults<ChecklistItem>

    @FetchRequest(
        entity: ChecklistItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ChecklistItem.sequence, ascending: true)],
        predicate: NSPredicate(format: "category == %@", "Arrival")
        )
    private var arriveItems: FetchedResults<ChecklistItem>

    var body: some View {
        NavigationView {
            
            GeometryReader { geometry in

                VStack {

                    // Header
                    ZStack(alignment: .topLeading, content: {
                        Image("truck-rv")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    })

                    // Checklist Sections
                    List {
                        
                        Section(header: Text("Pre-Trip")) {
                            
                            ForEach(preTripItems, id: \.self) { item in
                                
                              NavigationLink(destination: DetailView(listItem: item)) {
                                  ChecklistRow(item: item)
                              }
                                
                            }

                        } // Pre-Trip Section

                        Section(header: Text("Departure")) {
                            
                            ForEach(departItems, id: \.self) { item in
                                
                              NavigationLink(destination: DetailView(listItem: item)) {
                                  ChecklistRow(item: item)
                              }
                                
                            }

                        } // Departure Section

                        Section(header: Text("Arrival")) {
                            
                            ForEach(arriveItems, id: \.self) { item in
                                
                              NavigationLink(destination: DetailView(listItem: item)) {
                                  ChecklistRow(item: item)
                              }
                                
                            }

                        } // Arrival Section

                    } // List
                    .padding(.top, -8)
                    .listStyle(PlainListStyle())

                    
                } // VStack
                .blackNavigation
                .navigationBarTitle("RV Checklist", displayMode: .inline)
                .navigationBarItems(
//                    leading: (
//                        Button(action: {
//                            withAnimation {
//                                self.showMenu.toggle()
//                            }
//                        }) {
//                            Image(systemName: "line.horizontal.3")
//                                .imageScale(.large)
//                        }
//                    ),
                    trailing: (
                        Button(action: {
                            menuSelection = "Add"
                        }) {
                            Image(systemName: "plus")
                                .imageScale(.large)
                        }
                    )
                ) // navigationBarItems

                
            } // GeometryReader
            
        } // NavigationView
        .accentColor( .black)   // Sets back button color

    } // Body
    
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
