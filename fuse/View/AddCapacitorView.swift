//
//  AddCapacitorView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/13.
//

import SwiftUI

struct AddCapacitorView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var init_balance = 0
    
    var body: some View {
        Form {
            Section {
                TextField("Capacitor name", text: $name)
                TextField("\(Int(init_balance))", value: $init_balance, formatter: NumberFormatter()).keyboardType(.numberPad)
                
                
             
                
                HStack {
                    Spacer()
                    Button("Submit"){
                        DataController().addCapacitor(name: name, init_balance: Int32(init_balance), context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct AddCapacitorView_Previews: PreviewProvider {
    static var previews: some View {
        AddCapacitorView()
    }
}
