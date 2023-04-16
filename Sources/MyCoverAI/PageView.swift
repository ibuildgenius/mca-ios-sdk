//
//  PageView.swift
//  mca-ios-sdk
//
//

import SwiftUI

struct PageView: View {
    var image: String
    var content: String?
    
    var body: some View {
        
        VStack(alignment: .center) {
            Image(uiImage: SCImage(name: image)!).resizable().frame(width: 60, height: 60)
                .padding(16)
            
            if content != nil {
                HTMLStringView(htmlContent: content!).padding(.horizontal, 12)
                
            }
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(image: "", content: "")
    }
}
