//
//  EditFlowView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/11.
//

import SwiftUI

struct EditFlowView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var flow: FetchedResults<Flow>.Element
    
    @State private var name = ""
    @State private var amount = 0
    @State private var date = Date()
    @State private var isSpending = true
    @State private var status = ""
    
    let status_list = ["Confirmed", "Pending", "Uncertain"]
    
    var body: some View {
        Form {
            Section {
                Picker("Status", selection: $status) {
                                        ForEach(status_list, id: \.self) {
                                            Text($0)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .onAppear{
                                        name = flow.name!
                                        amount = Int(flow.amount)
                                        date = flow.date!
                                        status = status_list[Int(flow.status)]
                                    }
                TextField("\(flow.name!)",text: $name)
                    
                
                
                HStack{
                    Button {
                        isSpending.toggle()
                    } label: {
                        Label("", systemImage: isSpending ?  "minus.circle" : "plus.circle").font(.system(size: 25))
                    }
                    TextField("\(Int(amount))", value: $amount, formatter: NumberFormatter()).keyboardType(.numberPad)
                    
                }
                DatePicker("Date", selection: $date,displayedComponents: .date)
                
                HStack{
                    Spacer()
                    Button("Submit"){
                        DataController().editFlow(flow: flow, name: name, amount: Int32(amount), date: date, status: Int16(status_list.firstIndex(of: status)!), context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}

