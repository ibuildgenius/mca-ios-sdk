//
//  LottieView.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 21/02/2023.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let lottieFile: String
    var loopMode: LottieLoopMode = .loop
    
    let animationView = LottieAnimationView()
    
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
            let view = UIView(frame: .zero)
            
        animationView.animation = LottieAnimation.named(lottieFile, bundle: .module)
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = loopMode
            animationView.play()
            
            animationView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(animationView)
            
            NSLayoutConstraint.activate([
                animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
                animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
            
            return view
        }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {}


    
    
    
}
