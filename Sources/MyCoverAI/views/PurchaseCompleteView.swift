//
//  SwiftUIView.swift
//  
//
//  Created by Fuhad on 26/03/2024.
//

import SwiftUI

struct PurchaseCompleteView: View {
    var body: some VStack {
        LottieView(lottieFile: "check", loopMode: .playOnce)
            .frame(width: 180, height: 180).padding(13)
        
        Text(completeText).font(metropolisBold18)
    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
}

struct PurchaseCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseCompleteView()
    }
}
