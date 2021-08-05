//
//  DetailView.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/13/21.
//

import SwiftUI

struct DetailView: View {
    
    @State private var isShowingImagePicker = false
    @State private var isShowingEdit = false
    
    var listItem: ChecklistItem
    
    var body: some View {

        NavigationLink(destination: ImagePicker(), isActive: $isShowingImagePicker) {
            EmptyView()
        }
        NavigationLink(destination: EditItem(item: listItem), isActive: $isShowingEdit) {
            EmptyView()
        }

        VStack {

            //TODO: refactor to getSafeImage method
            let name = listItem.wrappedImageName
            let uiImage = (UIImage(named: name) ?? UIImage(systemName: name) ?? UIImage(systemName: "photo")!)
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .gesture(
                LongPressGesture(minimumDuration: 1)
                    .onEnded { _ in
                        isShowingImagePicker = true
                    }
                )
            
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
        .navigationBarItems(
            trailing: (
                Button(action: {
                    isShowingEdit = true
                }) {
                    Image(systemName: "pencil.circle")
                        .imageScale(.large)
                }
            )
        )
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
        imageName: "photo",
        sequence: 1,
        category: "Test")
    )
  }
}

