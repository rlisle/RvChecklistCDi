//
//  ImagePicker.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 8/4/21.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
//    @Binding var image: UIImage
    var title: String?
//    private var fetchRequest: FetchRequest<ChecklistItem>
    @Binding var listItem: ChecklistItem

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
//    init(image: UIImage) {
//        self.fetchRequest = FetchRequest(
//            sortDescriptors: [NSSortDescriptor(keyPath: \ChecklistItem.sequence, ascending: true)],
//            predicate: NSPredicate(format: "title = %@", title))
//    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                // Handle newly selected image
//                parent.image = uiImage
                parent.listItem.photoData = uiImage.pngData()
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
}
