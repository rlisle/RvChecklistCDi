//
//  ChecklistSection.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 4/10/21.
//

import SwiftUI

struct ChecklistSection: View {
    
    @State var category: String = ""
    @State var showCompleted: Bool = true

    private var fetchRequest: FetchRequest<ChecklistItem>
        
    var body: some View {
        Section(header: Text(category)) {
            ForEach(fetchRequest.wrappedValue, id: \.self) { listItem in
                NavigationLink(destination: DetailView(listItem: listItem)) {
                    ChecklistRow(item: listItem)
                }
            }
            // Does this do anything?
            .onDelete(perform: { indexSet in
                print("Delete \(indexSet)!")
                deleteItems(at: indexSet)
            })
        }.padding([.leading], 16)
    }
    
    func deleteItems(at offsets: IndexSet) {
        print("deleteItems at \(offsets)")
        //items.remove(atOffsets: offsets)  // TODO:
    }
    
    // category == category AND (isdone == false || showCompleted == true)
    init(category: String, showCompleted: Bool) {
        let p1 = NSPredicate(format: "category = %@", category)
        let p2 = NSPredicate(format: "isDone = NO")
        let p3 = NSPredicate(format: "isDone = %d", showCompleted)
        let orPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [p2,p3])
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1,orPredicate])
        self.fetchRequest = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \ChecklistItem.sequence, ascending: true)],
            predicate: andPredicate)
        self.category = category
        self.showCompleted = showCompleted
    }
}

struct ChecklistSection_Previews: PreviewProvider {
        
    static var previews: some View {
        ChecklistSection(category: "Pre-Trip", showCompleted: true)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
