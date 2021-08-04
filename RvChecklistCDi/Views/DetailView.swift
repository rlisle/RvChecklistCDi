//
//  DetailView.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/13/21.
//

import SwiftUI

struct DetailView: View {
    
    var listItem: ChecklistItem
    
    var body: some View {

        VStack {

            if let imageName = listItem.imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            Text(listItem.title ?? "Unnamed Todo")
                .font(.title2)
                .multilineTextAlignment(.center)
                .lineLimit(3)
            
            Divider()
            
            Text(listItem.instructions ?? "Just do it.")
            
            Spacer()
        }
        .padding()
        .blackNavigation
        .navigationBarTitle(listItem.wrappedTitle, displayMode: .inline)
//        .navigationBarItems(leading: (
//            Button(action: {
//                withAnimation {
//                    self.showMenu.toggle()
//                }
//            }) {
//                Image(systemName: "line.horizontal.3")
//                    .imageScale(.large)
//            }
//        ),
//        trailing: (
//            Button(action: {
//                NavigationLink(
//                    destination: AddItem(),
//                    label: {
//                        Text("")
//                    })
//            }) {
//                Image(systemName: "plus")
//                    .imageScale(.large)
//            }
//        ))

    }
}

struct DetailView_Previews: PreviewProvider {
    
  static var previews: some View {
    let persistenceController = PersistenceController.shared
    let context = persistenceController.container.viewContext
    DetailView(listItem: ChecklistItem(
        context: context,
        title: "Test Item",
        instructions: "Do this then that",
        imageName: "none",
        sequence: 1,
        category: "Test")
    )
  }
}

