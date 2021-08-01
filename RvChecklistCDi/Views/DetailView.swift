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
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct DetailView_Previews: PreviewProvider {
//  static var previews: some View {
//    DetailView(listItem: CheckListItem())
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//  }
//}

