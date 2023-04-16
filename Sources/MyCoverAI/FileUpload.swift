//
//  FileUpload.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 27/02/2023.
//

import SwiftUI
//````import FilePicker

struct FileUpload: View {
    
    var body: some View {
        Text("hello")
    }
    
//    @State private var url: URL? = nil
//
//    var progressInterval: ClosedRange<Date> {
//           let start = Date()
//           let end = start.addingTimeInterval(60 * 10)
//           return start...end
//       }
//
//    func upload() async {
//
//        let result = await networkService.uploadFile(file:url!)
//        if(result != nil) {
//            print("upload response is \(result?.responseText ?? "nonexist")")
//        }
//    }
//
//    var body: some View {
//        VStack {
//            if(url != nil) {
//
//                let im = try! Data(contentsOf: url!)
//                let image = UIImage(data: im)
//
//                Image(uiImage: image!).resizable().scaledToFit()
//            }
//
//            FilePicker(types: [.image], allowMultiple: false) { urls in
//                print("selected \(urls[0].absoluteString) files")
//
//                url = urls[0]
//
//            } label: {
//                CustomTextField(
//                    label: "select file",
//                    inputType: resolveKeyboardType(inputType: InputType.text),
//                    hint: "selectfile",
//                    disabled: true,
//                    text: ""
//                )
//            }
//
//
//            Button("upload") {
//                Task {
//                    await upload()
//                }
//            }
//        }
//    }
}

struct FileUpload_Previews: PreviewProvider {
    static var previews: some View {
        FileUpload()
    }
}
