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
    
    @State var listItem: ChecklistItem
    
    var body: some View {

        VStack {

            Image(uiImage: listItem.wrappedPhoto)
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
        .sheet(isPresented:  $isShowingImagePicker, onDismiss: loadImage) {
            ImagePicker(listItem: $listItem)
        }
    }
    
    func loadImage() {
        //TODO: save image to checklist
        print("loadImage")
    }
}

struct DetailView_Previews: PreviewProvider {
    
  static var previews: some View {
    let persistenceController = PersistenceController.shared
    let context = persistenceController.container.viewContext
    DetailView(listItem: ChecklistItem(
        context: context,
        title: "Test Item",
        instructions: "Do this,\nthen do that.\nFinally, do this...",
        photo: UIImage(systemName: "photo")!,
        sequence: 1,
        category: "Test")
    )
  }
}

