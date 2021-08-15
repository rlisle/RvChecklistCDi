//
//  HeaderView.swift
//  RvChecklist
//
//  Created by Ron Lisle on 3/24/21.
//

import SwiftUI

struct HeaderView: View {
    
    var body: some View {
        
        // TODO: Shrink header when scrolling
        ZStack(alignment: .topLeading, content: {
            
            Image("truck-rv")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
        })
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .previewLayout(.fixed(width: 300, height: 210))
            .previewDisplayName("Header")
    }
}
