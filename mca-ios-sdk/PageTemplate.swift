//
//  PageTemplate.swift
//  mca-ios-sdk
//

import SwiftUI

struct PageTemplate: View {
    let onBackPressed: () -> Void
    let mContent:() -> AnyView
    
    
    var body: some View {
        ZStack {
            ZStack {
                Image("bg").resizable().frame(width: 50, height: 50, alignment: Alignment.topLeading)
                Image("bg").resizable().frame(width: 50, height: 50, alignment: Alignment.bottomTrailing)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                HStack {
                    Image(systemName: "chevron.backward").onTapGesture {
                        onBackPressed()
                    }.foregroundColor(colorPrimary)
                    Text("").frame(maxWidth: .infinity)
                }.padding(12)
                
                Image("logo").resizable().frame(width: 135, height: 32)
                
                VStack {
                    mContent()
                }.frame(maxHeight: .infinity)
                
                
                Image("powered_by").resizable().frame(width: 130, height: 20)
                
            }
        }
        
    }
}

struct PageTemplate_Previews: PreviewProvider {
    static var previews: some View {
        PageTemplate(onBackPressed: {}, mContent: {return AnyView(Text("")) })
    }
}
