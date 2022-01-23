//
//  Settings.swift
//  Cur-Culator
//
//  Created by Dennis Nikas on 4/10/21.
//

import SwiftUI

struct Settings: View {
    @State private var showingPopover = false
    @AppStorage("code") private var code = "USD"
    @AppStorage("convert") private var convert = "USD"
    @State var submit = false
    @State var datas: ReadData
    @State var fetch: FetchData
    @State var base = ""
    @State var target = ""
    
    var body: some View {
        
        Button(action: {
            self.base = code
            self.target = convert
            showingPopover = true
        }, label: {
            Image(systemName: "gear")
                .font(Font.title.weight(.bold))
                .foregroundColor(.black)
                .frame(width: 44, height: 44)
                .shadow(color: Color.green.opacity(0.3), radius: 10, x: 0, y: 10)
                .cornerRadius(20)
                .offset(x: 10, y: 0)
        })
        
            .popover(isPresented: $showingPopover) {
                NavigationView{
                    Form {
                        Picker(selection: $base, label: Text("Базовая валюта")) {
                            
                            
                            Filter(codes: datas.codes, names: datas.names )
                        }
                        Picker(selection: $target, label: Text("Вторая валюта")) {
                            
                            
                            Filter(codes: datas.codes, names: datas.names )
                        }
                        
                        Button("Сохранить") {
                            self.submit.toggle()
                            code = self.base
                            convert = self.target
                            fetch.update()
                            fetch.updateFlags(baseCode: code, targetCode: convert)
                        }
                        .buttonStyle(BlueButtonStyle())
                        .padding()
                        .background(Color.black)
                        .cornerRadius(5)
                        .alert(isPresented: $submit, content: {
                            Alert(title: Text("Сохранено"), message: Text("Базовая валюта выбрана: " + code + "  Вторая валюта выбрана: " + convert))
                        })
                    }
                    .navigationBarTitle("Настройки")
                }
                
            }
    }
}


