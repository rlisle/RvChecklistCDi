//
//  ChecklistSection.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 4/10/21.
//

import SwiftUI

struct ChecklistSection: View {
    
    var name: String
    var heading: Text
    var showCompleted: Bool
    var items: FetchedResults<ChecklistItem>    //TODO: move to @Environment?
    
    var body: some View {
        Section(header: heading) {
            let filteredPreTripItems = items.filter { $0.category == name && ($0.isDone == false || showCompleted == true) }
            ForEach(filteredPreTripItems) { listItem in
                NavigationLink(destination: DetailView(listItem: listItem)) {
                    ChecklistRow(item: listItem)
                }
            }
            .onDelete(perform: { indexSet in
                print("Delete \(indexSet)!")
                //TODO: delete item?
            })
        }.padding([.leading], 16)
    }
}

//struct ChecklistSection_Previews: PreviewProvider {
//    static var previews: some View {
//        let items = [
//            ChecklistItem("")
//        ]
//        ChecklistSection(name: "Beforehand", heading: "Beforehand: 1 of 2 done", showCompleted: true)
//    }
//}
