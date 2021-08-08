//
//  MenuView.swift
//  RvChecklistCDi
//
//  Side Menu
//
//  Created by Ron Lisle on 7/13/21.
//

import SwiftUI

struct MenuView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @Binding var showMenu: Bool
    @Binding var showCompleted: Bool
    @Binding var selection: String?

    var body: some View {
        VStack(alignment: .leading) {
            MenuRow(title: showCompleted ? "Hide Done" : "Show Done", iconName: showCompleted ? "eye.slash" : "eye", action: {
                showCompleted.toggle()
                withAnimation {
                    showMenu = false
                }
            })
            .padding(.top, 80)
            MenuRow(title: "Reset List", iconName: "clear", action: {
                clearChecklist()
                withAnimation {
                    showMenu = false
                }
            })
            MenuRow(title: "Add Item", iconName: "plus", action: {
                selection = "Add"
                withAnimation {
                    showMenu = false
                }
            })
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 32/255, green: 32/255, blue: 32/255))
        .edgesIgnoringSafeArea(.all)
    }
    
    private func clearChecklist() {
        do {
            print("Clearing checklist")
            try PersistenceController.reloadChecklist(context: viewContext)
            try viewContext.save()
        } catch {
            print("Error reseting checklist \(error)")
        }
    }

}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showMenu: .constant(true),
                 showCompleted: .constant(true),
                 selection: .constant("None"))
            .previewLayout(.fixed(width: 180, height: 720))
    }
}
