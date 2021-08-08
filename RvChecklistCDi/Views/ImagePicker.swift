//
//  ImagePicker.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 8/4/21.
//

import SwiftUI

//TODO: Move to iOS15 when available
struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var listItem: ChecklistItem

    var title: String?
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.editedImage] as? UIImage {
                let adjustedImage = uiImage.upOrientationImage()
                
                //TODO: Resize image
                let size = CGSize(width: 64.0, height: 64.0)    // testing really small
                let renderer = UIGraphicsImageRenderer(size: size)
                let resizedImage = renderer.image { (context) in
                    adjustedImage.draw(in: CGRect(origin: .zero, size: size))
                }
                
                parent.listItem.photoData = resizedImage.pngData()
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

extension UIImage {
    func upOrientationImage() -> UIImage {
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result ?? self
        }
    }
}
