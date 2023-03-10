//
//  AddCapacitorView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/13.
//

import SwiftUI



struct AddCapacitorView: View {
    
    enum Field: Hashable {
            case name
            case init_balance
        }
    
    
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var init_balance: Int?
    
    @State private var enable: Bool = true
    
    @FocusState var focusedField: Field?
    
    
    
    var body: some View {
        NavigationView{
            
        
        Form {
            Section {
                
                TextField("Capacitor name", text: $name).focused($focusedField, equals: .name)
                    .toolbar {
                                      ToolbarItemGroup(placement: .keyboard) {
                                          Spacer()         // 右寄せにする
                                          Button("Close") {
                                              focusedField = nil  //  フォーカスを外す
                                          }
                                      }
                    }
                HStack{
                    Text("¥ ")
                    TextField("Init balance", value: $init_balance,format: .number).keyboardType(.numberPad).focused($focusedField, equals: .init_balance)
                        
                    
                    
                }
               
                
                
             
                
                HStack {
                    Spacer()
                    Button("Save"){
                        enable = false
                        DataController().addCapacitor(name: name, init_balance: Int32(init_balance ?? 0), context: managedObjContext)
                        dismiss()
                    }.disabled(!enable)
                    Spacer()
                }
            }
        }.navigationTitle("Add Capacitor")
            
        }
    }
        
        
}

//struct AddCapacitorView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCapacitorView()
//    }
//}
