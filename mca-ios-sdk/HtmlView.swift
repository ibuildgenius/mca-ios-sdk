//
//  HtmlView.swift
//  mca-ios-sdk
//
//

import WebKit
import SwiftUI

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        
        // TODO: if you're here, please improve styling
        let x = "<style> body { font-size: 36px;  font-family: 'SpaceGroteskMedium'   src: url(\"Metropolis-Medium.otf\") format('opentype'); line-height: 60px; overflow: hidden; } </style>"
        
     
        uiView.loadHTMLString(htmlContent.appending(x), baseURL: nil)
    }
}
