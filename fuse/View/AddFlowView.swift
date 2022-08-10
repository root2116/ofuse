//
//  AddFlowView.swift
//  fuse
//
//  Created by araragi943 on 2022/06/09.
//

import SwiftUI

struct AddFlowView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var amount = 0
    @State private var date = Date()
//    @State private var capacitor_id = UUID()
//    @State private var status = 0
    
    var body: some View {
        Form {
            Section {
                
                TextField("Flow name", text: $name)
                HStack{
                    Text("Amount: ")
                    TextField("\(Int(amount))", value: $amount, formatter: NumberFormatter()).keyboardType(.numberPad)
                }
                
                DatePicker("Date", selection: $date,displayedComponents: .date)
                
                HStack {
                    Spacer()
                    Button("Submit"){
                        DataController().addFlow(name: name, amount: Int32(amount), date: date,  context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct AddFlowView_Previews: PreviewProvider {
    static var previews: some View {
        AddFlowView()
    }
}
