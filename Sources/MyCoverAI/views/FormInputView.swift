//
//  SwiftUIView.swift
//  
//
//  Created by Fuhad on 26/03/2024.
//

import SwiftUI

struct FormInputView: View {
    var body: some  VStack {
        
        HStack(alignment: .center) {
            Image(uiImage: SCIcon(sysName: "info.circle.fill")!).resizable().frame(width: 15, height: 15).foregroundColor(colorPrimary)
            
            Text("Enter details as it appears on legal documents")
                .font(metropolisRegular13)
                .padding(.leading, 5)
        }.padding(9).frame(alignment: .leading).background(colorPrimaryTrans)
        
        HStack {
            VStack{}.frame(maxWidth: .infinity)
            Text("Underwritten by: \(product.prefix.capitalized)").font(metropolisRegularSM)
        }
        
        
        VStack {
            let forms = formSet[currentFormSetIndex]
            ForEach(forms) {form in
                
                VStack(alignment: .leading) {
                    
                    if(form.input_type == InputType.date) {
                        
                        Text(form.label).font(metropolisRegularSM)
                        
                        DatePickerTextField(placeholder: "", date: $date, onDateChange: {
                            value in
                            
                            fields[form.name] = value
                            
                            print(value)
                            
                        }).padding(.all, 7)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.gray, lineWidth: 1)
                            )
                            .background(Color.gray.opacity(0.1))
                        
                        
                        
                        
                    } else if(form.input_type == InputType.file) {
                        FilePicker(types: [.data], allowMultiple: false) { urls in
                            print("selected \(urls[0]) files")
                            if (urls[0] != nil) {
                                files[form.name] = urls[0]
                            }
                        } label: {
                            CustomTextField(
                                label: form.label,
                                inputType: resolveKeyboardType(inputType: form.input_type),
                                hint: files[form.name]?.description ?? form.description,
                                disabled: true,
                                text: name
                            )
                        }
                    }
                    
                    else {
                        
                        if(form.form_field.name!.lowercased().contains("select")) {
                            if(selectItems[form.name] != nil) {
                  
                                Menu(content: {
                                    ForEach(selectItems[form.name]!, id: \.self) {
                                        item in
                
                                
                                        Button("\(item.description)") {
                                            fields[form.name] = item.value
                                        }
                                    }
                                }, label: {
                                    CustomTextField(
                                        label: "\(form.label)",
                                        inputType: resolveKeyboardType(inputType: form.input_type),
                                        hint: "\(fields[form.name] ?? form.description)",
                                        disabled: true,
                                        text: "\(fields[form.name] ?? "")",
                                        onTap: {}
                                    )
                                })
                                
                            } else {
                                
                            }
                        } else {
                            
                            CustomTextField(
                                label: form.label,
                                inputType: resolveKeyboardType(inputType: form.input_type),
                                hint: form.description,
                                disabled: false,
                                text: "\(fields[form.name] as? String ?? "") ",
                                onTap: {
                                    print("\(form.label) is \(fields[form.label] ?? "")")
                                },
                                onChange: {value in
                                    
                                    if(form.data_type == DataType.number) {
                                        fields[form.name] = Int(value.trimmingCharacters(in: .whitespacesAndNewlines))
                                    } else {
                                        fields[form.name] = value.trimmingCharacters(in: .whitespacesAndNewlines)
                                    }
                                    
                                    print(value.description)
                                    print("form field value \(form.data_type) \(fields[form.name] ?? "")")
                                }
                            )
                        }
                    }
                    
                    
                }.padding(.vertical, 4).task {
                    let _: () = await getSelectField(form: form)
                }
                
            }
        }.padding(.top,15)
        
        VStack {}.frame(maxHeight: .infinity)
    }
}

struct FormInputView_Previews: PreviewProvider {
    static var previews: some View {
        FormInputView()
    }
}
