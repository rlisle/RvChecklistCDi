//
//  Checkmark.swift
//  RvChecklist
//
//  Created by Ron Lisle on 3/24/21.
//

import SwiftUI

struct Checkmark: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isDone: Bool
    
    var body: some View {
        Button(action: {
            print("Button toggle")
            isDone.toggle()
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Error saving toggled item: \(nsError), \(nsError.userInfo)")
            }
        }) {
            Image(systemName: isDone ? "checkmark.square" : "square")
                .contentShape(Rectangle())
                .onTapGesture {
                    print("Image toggle")
                    isDone.toggle()
                }
        }
    }
}

struct Checkmark_Previews: PreviewProvider {
    static var previews: some View {
        Checkmark(isDone: .constant(true))
        .previewLayout(.fixed(width: 40, height: 40))
        .previewDisplayName("Checkmark")
    }
}
