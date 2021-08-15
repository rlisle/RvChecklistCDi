//
//  ContentView.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 3/28/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State private var showCompleted = true
    @State var showMenu = false
    @State private var menuSelection: String? = nil

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ChecklistItem.sequence, ascending: true)])
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
                
        return NavigationView {
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    VStack {
                        Group {
                            // Side menu selected destinations
                            NavigationLink(destination: AddItem(),
                                           tag: "Add",
                                           selection: $menuSelection,
                                           label: { EmptyView() })
                        }
                        
                        // TODO: Shrink header when scrolling
                        HeaderView()
                        
                        // Maybe use LazyVStack instead?
                        List {
                            
                            ChecklistSection(category: "Pre-Trip",
                                             showCompleted: showCompleted)
                            
                            ChecklistSection(category: "Departure",
                                             showCompleted: showCompleted)
                            
                            ChecklistSection(category: "Arrival",
                                             showCompleted: showCompleted)
                            
                        } // List
                        .listStyle(GroupedListStyle())
//                        .toolbar {
//                            EditButton()
//                        }
                        .animation(.easeInOut)
                        .overlay(items.isEmpty ? Text("No items found") : nil, alignment: .center)
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

                } // ZStack
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
                ),
                trailing: (
                    Button(action: {
                        menuSelection = "Add"
                    }) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                ))
            } // GeometryReader
        } // NavigationView
        .accentColor( .black)   // Sets back button color
//        .onAppear {
//            print("On Appear")
//        }
    }
    
//    private func sectionText(_ section: String) -> Text {
//        let doneCount = items.filter { $0.category == section && $0.isDone == true }.count
//        let sectionCount = items.filter {
//            $0.category == section
//        }.count
//
//        return Text("\(section) (\(doneCount) of \(sectionCount) items done)")
//    }
        
//    init() {
//        UINavigationBarAppearance().configureWithTransparentBackground()
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
