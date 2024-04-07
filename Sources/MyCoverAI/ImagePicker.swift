//
//  ImagePicker.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 23/02/2023.
//

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage
    @Binding var files: [String: URL]
    @Binding var formName: String
    @Binding var imageUrl: URL?
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) ->
    
    UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
         
            var parent: ImagePicker
         
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
        
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    parent.selectedImage = image
                    if let newImageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                        parent.imageUrl =  newImageUrl
                        parent.files[parent.formName] = newImageUrl
                    }
                }
                
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
    
}

