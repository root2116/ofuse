//
//  EditCapacitorView.swift
//  Fuse
//
//  Created by araragi943 on 2022/09/03.
//

import SwiftUI

struct EditCapacitorView: View {
    
    enum Field: Hashable {
            case name
            case init_balance
        }
    
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    

    var capacitor: FetchedResults<Capacitor>.Element
    
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var capacitors: FetchedResults<Capacitor>

    
    
    @State private var name = ""
    @State private var init_balance: Int?
    
    @State private var enable: Bool = true
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationView{
            
        
        Form {
            Section {
            
                TextField("Capacitor name", text: $name).focused($focusedField, equals: .name)
                    .toolbar {
                                      ToolbarItemGroup(placement: .keyboard) {
                                          Spacer()         // 右寄せにする
                                          Button("Close") {
                                              focusedField = nil //  フォーカスを外す
                                          }
                                      }
                    }.onAppear{
                        name = capacitor.name ?? ""
                        init_balance = Int(capacitor.init_balance)
                    }
                
                HStack{
                    Text("¥ ")
                    TextField("Init balance", value: $init_balance,format: .number).keyboardType(.numberPad).focused($focusedField, equals: .init_balance)
                        
                    
                    
                }
               
                
                
                
                HStack {
                    Spacer()
                    Button("Save"){
                        enable = false
                        DataController.shared.editCapacitor(capacitor: capacitor, name: name, init_balance: Int32(init_balance ?? 0), context: managedObjContext)
                        dismiss()
                    }.disabled(!enable)
                    Spacer()
                }
            }
        }.navigationTitle("Edit the capacitor")
            
        }
    }
        
   
}

//struct EditCapacitorView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditCapacitorView()
//    }
//}
