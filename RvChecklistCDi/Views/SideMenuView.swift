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
    @State var selectedTrip: Trip?

    var body: some View {
        VStack(alignment: .leading) {
            MenuRow(title: "Add New Trip", iconName: "plus", action: {
                selection = "Add"
                withAnimation {
                    showMenu = false
                }
            })
            .padding(.top, 100)
            MenuRow(title: showCompleted ? "Hide Done" : "Show Done", iconName: showCompleted ? "eye.slash" : "eye", action: {
                showCompleted.toggle()
                withAnimation {
                    showMenu = false
                }
            })
            MenuRow(title: "Reset List", iconName: "clear", action: {
                clearChecklist()
                withAnimation {
                    showMenu = false
                }
            })
            MenuRow(title: "Edit Trip", iconName: "car", action: {
                selection = "Edit"
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
            try PersistenceController.reloadChecklist(context: viewContext)
            try viewContext.save()
        } catch {
            print("Error clearing checklist")
        }
    }

}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(showMenu: .constant(true),
                 showCompleted: .constant(true),
                 selection: .constant("None"),
                 selectedTrip: nil)
            .previewLayout(.fixed(width: 180, height: 720))
    }
}
