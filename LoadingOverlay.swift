//
//  LoadingOverlay.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 27/02/2023.
//

import SwiftUI

struct LoadingOverlay: View {
    let loadingText: String
    
    var body: some View {
        VStack(alignment: .center) {
            LottieView(lottieFile: "loading", loopMode: .loop)
                                       .frame(width: 180, height: 180)
            Text(loadingText).font(metropolisBold18).foregroundColor(Color.white)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center).background(Color.gray.opacity(0.8))
    }
}

struct LoadingOverlay_Previews: PreviewProvider {
    static var previews: some View {
        LoadingOverlay(loadingText: "Please  wait...")
    }
}
