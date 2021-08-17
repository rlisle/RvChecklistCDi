//
//  DetailView.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/13/21.
//

import SwiftUI

struct DetailView: View {

    @Environment(\.managedObjectContext) private var viewContext

    @State private var isShowingImagePicker = false
    @State private var isShowingCamera = false
    @State private var isShowingEdit = false
    @State private var isShowingDelete = false

    @StateObject var listItem: ChecklistItem
    
    var body: some View {

        return VStack {

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
        .navigationBarItems(trailing:
            HStack {
                Button(action: {
                    isShowingEdit = true
                }) {
                    Image(systemName: "pencil")
                        .imageScale(.large)
                }
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    Button(action: {
                        isShowingCamera = true
                    }) {
                        Image(systemName: "camera")
                            .imageScale(.large)
                    }
                }
                Button(action: {
                    isShowingDelete = true
                }) {
                    Image(systemName: "trash")
                        .imageScale(.large)
                }

            }
        )
        .sheet(isPresented:  $isShowingImagePicker, onDismiss: loadImage) {
            ImagePicker(listItem: listItem, sourceType: .photoLibrary)
        }
        .sheet(isPresented:  $isShowingCamera, onDismiss: loadImage) {
            ImagePicker(listItem: listItem, sourceType: .camera)
        }
        .sheet(isPresented:  $isShowingEdit, onDismiss: loadImage) {
            EditItem(item: listItem)
        }
        .sheet(isPresented:  $isShowingDelete, onDismiss: loadImage) {
            DeleteItem(item: listItem)
        }
    }
    
    func loadImage() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving new image")
        }
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

