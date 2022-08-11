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
    @State private var isSpending = true
    @State private var status = "Confirmed"
    
    let status_list = ["Confirmed", "Pending", "Uncertain"]
//    @State private var capacitor_id = UUID()
//    @State private var status = 0
    
    var body: some View {
        Form {
            Section {
                Picker("Status", selection: $status) {
                                        ForEach(status_list, id: \.self) {
                                            Text($0)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                TextField("Flow name", text: $name)
                HStack{
                    
                    Button {
                        isSpending.toggle()
                    } label: {
                        Label("", systemImage: isSpending ?  "minus.circle" : "plus.circle").font(.system(size: 25))
                    }
                    
                    
                    TextField("\(Int(amount))", value: $amount, formatter: NumberFormatter()).keyboardType(.numberPad)
                }
                
                DatePicker("Date", selection: $date,displayedComponents: .date)
                
                
                                    
                HStack {
                    Spacer()
                    Button("Submit"){
                        DataController().addFlow(name: name, amount: isSpending ?  Int32(-amount): Int32(amount) , date: date, status: Int16(status_list.firstIndex(of: status)!), context: managedObjContext)
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
