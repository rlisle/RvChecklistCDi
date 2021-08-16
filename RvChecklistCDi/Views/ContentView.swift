//
//  ContentView.swift
//  ContentView
//
//  Created by Ron Lisle on 8/13/21.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @Environment(\.managedObjectContext) private var viewContext

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

                        HeaderView()

                        // Checklist Sections
                        List {
                            
                            Section(header:
                                HStack {
                                    Text("Pre-Trip")
                                    Spacer()
                                Text("(\(numPreTripToGo()) of \(preTripItems.count) to go)")
                            }) {
                                
                                
                                if(preTripItems.count == 0) {
                                    Text("No Pre-Trip items found")
                                } else {
                                    ForEach(preTripItems.filter { isShown(item:$0) }, id: \.self) { item in
                                        
                                      NavigationLink(destination: DetailView(listItem: item)) {
                                          ChecklistRow(item: item)
                                      }
                                    }
                                    .onDelete(perform: deletePreTripItem)
                                }


                            } // Pre-Trip Section
                            .textCase(nil)
                            
                            Section(header:
                                HStack {
                                    Text("Departure")
                                    Spacer()
                                    Text("(\(numDepartToGo()) of \(departItems.count) to go)")
                            }) {

                                if(departItems.count == 0) {
                                    Text("No Depart items found")
                                } else {
                                    ForEach(departItems.filter { isShown(item:$0) }, id: \.self) { item in
                                        
                                      NavigationLink(destination: DetailView(listItem: item)) {
                                          ChecklistRow(item: item)
                                      }
                                    }
                                    .onDelete(perform: deleteDepartItem)
                                }

                            } // Departure Section
                            .textCase(nil)
                            
                            Section(header:
                                HStack {
                                    Text("Arrival")
                                    Spacer()
                                    Text("(\(numArriveToGo()) of \(arriveItems.count) to go)")
                            }) {

                                if(arriveItems.count == 0) {
                                    Text("No Arrival items found")
                                } else {
                                    ForEach(arriveItems.filter { isShown(item:$0) }, id: \.self) { item in
                                        
                                      NavigationLink(destination: DetailView(listItem: item)) {
                                          ChecklistRow(item: item)
                                      }
                                    }
                                    .onDelete(perform: deleteArriveItem)
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
    
    private func deletePreTripItem(at offsets: IndexSet) {
        guard let index = offsets.first else {
            return
        }
        print("Deleting Pre-Trip item \(index)")
        viewContext.delete(preTripItems[index])
        try? viewContext.save()
    }
    
    private func deleteDepartItem(at offsets: IndexSet) {
        guard let index = offsets.first else {
            return
        }
        print("Deleting Depart item \(index)")
        viewContext.delete(departItems[index])
        try? viewContext.save()
    }
    
    private func deleteArriveItem(at offsets: IndexSet) {
        guard let index = offsets.first else {
            return
        }
        print("Deleting Arrive item \(index)")
        viewContext.delete(arriveItems[index])
        try? viewContext.save()
    }
    
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
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
