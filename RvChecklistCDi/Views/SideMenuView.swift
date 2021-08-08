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
            
            Section(header: Text("Actions")) {
                
                MenuRow(title: "Add Item", iconName: "plus", action: {
                    selection = "Add"
                    withAnimation {
                        showMenu = false
                    }
                })
                .padding(.bottom, 60)
            }
            
            Section(header: Text("Settings")) {
                
                MenuRow(title: showCompleted ? "Hide Done" : "Show Done", iconName: showCompleted ? "eye.slash" : "eye", action: {
                    showCompleted.toggle()
                    withAnimation {
                        showMenu = false
                    }
                })
                .padding(.bottom, 60)
            }

            Section(header: Text("Danger!")){

                MenuRow(title: "Reset List", iconName: "clear", action: {
                    clearChecklist()
                    withAnimation {
                        showMenu = false
                    }
                })
            
            }
            
            Spacer()
        }
        .padding(.top, 80)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 32/255, green: 32/255, blue: 32/255))
        .foregroundColor(.gray)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func clearChecklist() {
        do {
            
            //TODO: issue warning that all photos will be lost
            
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
