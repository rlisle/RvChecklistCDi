//
//  ContentView2.swift
//  ContentView2
//
//  Created by Ron Lisle on 8/13/21.
//

import SwiftUI
import CoreData

struct ContentView2: View {
    
    @State private var showCompleted = true
    @State var showMenu = false
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
        
        // Close side menu
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            }

        NavigationView {
            
            GeometryReader { geometry in

                ZStack(alignment: .leading) {   // for sidemenu
                    
                    Group { // Was below following VStack
                        // Side menu selected destinations
                        NavigationLink(destination: AddItem(),
                                       tag: "Add",
                                       selection: $menuSelection,
                                       label: { EmptyView() })
                    }

                    VStack {

                        // Header
                        // TODO: Shrink header when scrolling
                        ZStack(alignment: .topLeading, content: {
                            Image("truck-rv")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        })

                        // Checklist Sections
                        List {
                            
                            Section(header:
                                HStack {
                                    Text("Pre-Trip")
                                    Spacer()
                                    Text("(\(numPreTripToGo()) to go)")
                            }) {
                                
                                
                                if(preTripItems.count == 0) {
                                    Text("No Pre-Trip items found")
                                } else {
                                    ForEach(preTripItems.filter { isShown(item:$0) }, id: \.self) { item in
                                        
                                      NavigationLink(destination: DetailView(listItem: item)) {
                                          ChecklistRow(item: item)
                                      }
                                    }
                                }


                            } // Pre-Trip Section
                            .textCase(nil)
                            
                            Section(header: Text("Departure (\(numDepartToGo()) to go)")) {
                                
                                if(departItems.count == 0) {
                                    Text("No Depart items found")
                                } else {
                                    ForEach(departItems.filter { isShown(item:$0) }, id: \.self) { item in
                                        
                                      NavigationLink(destination: DetailView(listItem: item)) {
                                          ChecklistRow(item: item)
                                      }
                                    }
                                }

                            } // Departure Section
                            .textCase(nil)
                            
                            Section(header: Text("Arrival (\(numArriveToGo()) to go)")) {
                                
                                if(arriveItems.count == 0) {
                                    Text("No Arrival items found")
                                } else {
                                    ForEach(arriveItems.filter { isShown(item:$0) }, id: \.self) { item in
                                        
                                      NavigationLink(destination: DetailView(listItem: item)) {
                                          ChecklistRow(item: item)
                                      }
                                    }
                                }

                            } // Arrival Section
                            .textCase(nil)

                        } // List
                        .padding(.top, -8)
                        .listStyle(PlainListStyle())    // Changed from GroupedListStyle
                        .animation(.easeInOut)
                        .toolbar {
                            EditButton()
                        }

                        
                    } // VStack
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: self.showMenu ? geometry.size.width/2 : 0)
                    .disabled(self.showMenu ? true : false)
                    if self.showMenu {
                        MenuView(showMenu: $showMenu,
                                 showCompleted: $showCompleted,
                                 selection: $menuSelection)
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .leading))
                    }

                } // ZStack for sidemenu
                .gesture(drag)
                .blackNavigation
                .navigationBarTitle("RV Checklist", displayMode: .inline)
                .navigationBarItems(
                    leading: (
                        Button(action: {
                            withAnimation {
                                self.showMenu.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .imageScale(.large)
                        }
                    ),
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
    
    func numPreTripToGo() -> Int {
        let total = preTripItems.count
        let done = preTripItems.filter { $0.isDone }.count
        return total - done
    }
    
    func numDepartToGo() -> Int {
        let total = departItems.count
        let done = departItems.filter { $0.isDone }.count
        return total - done
    }
    
    func numArriveToGo() -> Int {
        let total = arriveItems.count
        let done = arriveItems.filter { $0.isDone }.count
        return total - done
    }

    func isShown(item: ChecklistItem) -> Bool {
        return showCompleted == true || item.isDone == false
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
