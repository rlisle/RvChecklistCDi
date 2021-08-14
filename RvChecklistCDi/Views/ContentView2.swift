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
        sortDescriptors: [NSSortDescriptor(keyPath: \ChecklistItem.sequence, ascending: true)])
    private var items: FetchedResults<ChecklistItem>

    var body: some View {
        NavigationView {
            
            GeometryReader { geometry in

                VStack {
                    
//                  HeaderView()
                    ZStack(alignment: .topLeading, content: {
                        Image("truck-rv")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    })

                    //
                    List {
                        
                        Section(header: Text("Pre-Trip")) {
                            
                            ForEach(items, id: \.self) { item in
                                
                                Text(item.wrappedTitle)
//
//                              NavigationLink(destination: DetailView(listItem: item)) {
//                                  ChecklistRow(item: item)
//                              }
                            } // ForEach

                        } // Section
                        
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
