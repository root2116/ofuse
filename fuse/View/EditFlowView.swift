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
    
    var body: some View {
        Form {
            Section {
                TextField("\(flow.name!)",text: $name)
                    .onAppear{
                        name = flow.name!
                        amount = Int(flow.amount)
                        date = flow.date!
                    }
                HStack{
                    Text("Amount: ")
                    TextField("\(Int(amount))", value: $amount, formatter: NumberFormatter()).keyboardType(.numberPad)
                    
                }
                DatePicker("Date", selection: $date,displayedComponents: .date)
                
                HStack{
                    Spacer()
                    Button("Submit"){
                        DataController().editFlow(flow: flow, name: name, amount: Int32(amount), date: date, context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}

