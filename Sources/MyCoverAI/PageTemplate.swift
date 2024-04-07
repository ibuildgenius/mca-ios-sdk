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
                Image(uiImage: SCImage(name: "bg")!).resizable().frame(width: 50, height: 50, alignment: Alignment.topLeading)
                
                Image(uiImage: SCImage(name: "bg")!).resizable().frame(width: 50, height: 50, alignment: Alignment.bottomTrailing)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                HStack{
                    Image(uiImage: SCIcon(sysName: "chevron.backward")!).onTapGesture {
                        onBackPressed()
                    }.foregroundColor(colorPrimary)
                    Spacer()
                    
                    Image(uiImage: SCImage(name: "logo")!).resizable().frame(width: 135, height: 32)
                    Spacer()
                }.padding(.horizontal, 20).padding(.vertical)
                
//              
                
                VStack {
                    mContent()
                }.frame(maxHeight: .infinity)
                
                
                Image(uiImage: SCImage(name: "powered_by")!).resizable().frame(width: 130, height: 20)
                
            }
        }
        
    }
}

struct PageTemplate_Previews: PreviewProvider {
    static var previews: some View {
        PageTemplate(onBackPressed: {}, mContent: {return AnyView(Text("")) })
    }
}
