//
//  ImagePicker.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 8/4/21.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @State private var image: UIImage?  // Not a binding, we'll handle saving to core data here
    private var fetchRequest: FetchRequest<ChecklistItem>

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    init(title: String) {
        //Uh-oh, what happens when title changes? Probably need a persistent ID
        self.fetchRequest = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \ChecklistItem.sequence, ascending: true)],
            predicate: NSPredicate(format: "title = %@", title))
    }
}
