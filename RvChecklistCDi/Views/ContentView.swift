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
    @State private var showMenu = false
    @State private var menuSelection: String? = nil
    @State private var phase = "Pre-Trip"
    private var phases = ["Pre-Trip", "Departure", "Arrival"]

    @FetchRequest(
        entity: ChecklistItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ChecklistItem.sequence, ascending: true)]
        )
    private var items: FetchedResults<ChecklistItem>

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
                    
                    Group {
                        // Side menu selected destinations
                        NavigationLink(destination: AddItem(),
                                       tag: "Add",
                                       selection: $menuSelection,
                                       label: { EmptyView() })
                    }
                    
                    VStack {

                        HeaderView()
                            .padding(.bottom, -8)

                        Picker(selection: $phase, label: Text("Phase")) {
                            ForEach(phases, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.bottom, 0)
                        .background(Color.black)

                        // Checklist Section
                        List {
                            
                            Section(header:
                                HStack {
                                    Text(phase)
                                    Spacer()
                                Text("(\(numSelectedToGo()) of \(numSelectedItems()) to go)")
                                }
                                .padding(.vertical, 8)
                            ) {
                                
                                
                                if(numSelectedItems() == 0) {
                                    Text("No \(phase) items found")
                                } else {
                                    ForEach(items.filter { isShown(item:$0) && $0.category == phase }, id: \.self) { item in
                                        
                                      NavigationLink(destination: DetailView(listItem: item)) {
                                          ChecklistRow(item: item)
                                      }
                                    }
                                    .onMove(perform: onMove)
                                    .onDelete(perform: onDelete)
                                }


                            } // Pre-Trip Section
                            .textCase(nil)
                            

                        } // List
                        .padding(.top, -8)
                        .listStyle(PlainListStyle())    // Changed from GroupedListStyle
                        .animation(.easeInOut)
                        
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
                        HStack {
                            EditButton()
                            Button(action: {
                                menuSelection = "Add"
                            }) {
                                Image(systemName: "plus")
                                    .imageScale(.large)
                            }
                        }
                    )
                ) // navigationBarItems

                
            } // GeometryReader
            
        } // NavigationView
        .accentColor( .black)   // Sets back button color

        
        
    } // Body
    
    init() {
        print("ContentView init")
        UISegmentedControl.appearance().backgroundColor = .black
        UISegmentedControl.appearance().selectedSegmentTintColor = .selectable
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    private func onDelete(offsets: IndexSet) {
        print("onDelete")
        //items.remove(atOffsets: offsets)
    }

    // Maybe onMove is triggrering view redraw, stopping drag.
    private func onMove(source: IndexSet, destination: Int) {
        print("onMove: \(source) -> \(destination)")
        print("startIndex: \(source.startIndex), endIndex: \(source.endIndex)")
        //TODO: moving is accomplished by modifying the sequence numbers
        
//        // 1st get a filtered list of all the items in this category
//        let list = items.filter { isShown(item:$0) && $0.category == phase }
//
//        // Then sort by sequence
//        let sortedList = list.sorted(by: { $0.sequence < $1.sequence })
//
//        // Then rewrite the sequence numbers
//        let savedDest = sortedList[0].sequence
//        sortedList[0].sequence = sortedList[1].sequence
//        sortedList[1].sequence = savedDest

        // Method from post https://stackoverflow.com/questions/59742218/swiftui-reorder-coredata-objects-in-list
        let list = items.filter { isShown(item:$0) && $0.category == phase }
        var revisedItems = list.sorted(by: { $0.sequence < $1.sequence })
//        var revisedItems: [ChecklistItem] = items.map { $0 }
        revisedItems.move(fromOffsets: source, toOffset: 0) //destination)
        var index: Int16 = 1000    // TODO: may want to set different values for each category
        for item in revisedItems {
            item.sequence = index
            index += 10
        }
        
        //items.move(fromOffsets: source, toOffset: destination)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error saving updated sequences: \(nsError), \(nsError.userInfo)")
        }
    }

    func numSelectedToGo() -> Int {
        let done = items.filter { $0.category == phase && $0.isDone }.count
        return numSelectedItems() - done
    }
    
    func numSelectedItems() -> Int {
        return items.filter { $0.category == phase }.count
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
