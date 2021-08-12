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

    @FetchRequest var sectionItems: FetchedResults<ChecklistItem>
        
    var body: some View {
        print("body category = \(category)")
        return Section(header: Text(category)) {
            ForEach(sectionItems, id: \.self) { listItem in
                NavigationLink(destination: DetailView(listItem: listItem)) {
                    ChecklistRow(item: listItem)
                }
            }
            // This is not working. Swipe item right-to-left.
            // Should Work with ForEach or List
            .onDelete(perform: { indexSet in
                print("Delete \(indexSet)!")
                deleteItems(at: indexSet)
            })
            //.navigationBarItems(leading: EditButton())
        }
        .padding([.leading], 16)
    }
    
    func deleteItems(at offsets: IndexSet) {
        print("deleteItems at \(offsets)")
        //sectionItems.remove(atOffsets: offsets)
    }
    
    // category == category AND (isdone == false || showCompleted == true)
    init(category: String, showCompleted: Bool) {
        let p1 = NSPredicate(format: "category = %@", category)
        let p2 = NSPredicate(format: "isDone = NO")
        let p3 = NSPredicate(format: "isDone = %d", showCompleted)
        let orPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [p2,p3])
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1,orPredicate])
        self._sectionItems = FetchRequest(
            entity: ChecklistItem.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \ChecklistItem.sequence, ascending: true)],
            predicate: andPredicate)
        self.category = category
        self.showCompleted = showCompleted
        print("End of init category = \(category)")
    }
}

struct ChecklistSection_Previews: PreviewProvider {
        
    static var previews: some View {
        ChecklistSection(category: "Pre-Trip", showCompleted: true)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
