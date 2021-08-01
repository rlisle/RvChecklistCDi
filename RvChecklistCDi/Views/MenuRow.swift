//
//  MenuRow.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 7/20/21.
//

import SwiftUI

struct MenuRow: View {
    
    @State var title: String
    @State var iconName: String
    @State var action: () -> Void
    
    var body: some View {
        
        Button(action: {
            print("Invoking \(title)")
            action()
        }) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text(title)
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 30)
        }
    }
}

struct MenuRow_Previews: PreviewProvider {
    static var previews: some View {
        MenuRow(title: "Menu Item", iconName: "person", action: {
            print("Action tapped")
        })
        .previewLayout(.fixed(width: 320, height: 60))
        .previewDisplayName("Checkmark")
    }
}
