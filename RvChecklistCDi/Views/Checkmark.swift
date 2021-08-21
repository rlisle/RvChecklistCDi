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

        ZStack {
            Image(systemName: isDone ? "checkmark.square" : "square")
                .foregroundColor(isDone ? .selectable : .black)
                .contentShape(Rectangle())
        }
        .onTapGesture {
            toggleIsDone()
        }
    }
    
    func toggleIsDone() {
        print("Checkbox toggle")
        isDone.toggle()
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error saving toggled item: \(nsError), \(nsError.userInfo)")
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
