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
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var capacitors: FetchedResults<Capacitor>
    
    var flow: FetchedResults<Flow>.Element
    
    @State private var name = ""
    @State private var amount = 0
    @State private var date = Date()
    @State private var right = true
    @State private var status = ""
    @State private var from: UUID? = UUID()
    @State private var to: UUID? = UUID()
    
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
                                        from = flow.from!.id!
                                        to = flow.to!.id!
                                    }
                TextField("Flow name",text: $name)
                    
                
                
                HStack{
                   
                    Text("¥ ")
                    TextField("Amount", value: $amount,format: .number).keyboardType(.numberPad)
                    
                }
                DatePicker("Date", selection: $date,displayedComponents: .date)
                
                GeometryReader { metrics in
                    
                        
                        HStack(alignment: .center) {
                            Menu(getName(items:capacitors,id: from!)) {
                                Picker("From Capacitor",selection: $from){
                                    ForEach(capacitors, id: \.id){ cap in
                                        Text(cap.name!)
                                    }
                                }
                                
                            }.frame(width:metrics.size.width * 0.40)
                            
                            
                            Button {
                                right.toggle()
      
                            } label: {
                                Label("", systemImage: right ?  "arrow.right.square.fill" : "arrow.left.square.fill").font(.system(size: 25))
                            }.frame(width: metrics.size.width * 0.20)
        
                            Menu(getName(items:capacitors,id: to!)) {
                                Picker("To Capacitor",selection: $to){
                                    ForEach(capacitors, id: \.id){ cap in
                                        Text(cap.name!)
                                    }
                                }
                            }.frame(width:metrics.size.width * 0.40)
                                
                        }.frame(width:metrics.size.width, height: metrics.size.height, alignment: .center)
                       
                    
                }
                
                HStack{
                    Spacer()
                    Button("Save"){
                        DataController().editFlow(flow: flow, name: name, amount: Int32(amount), date: date, status: Int16(status_list.firstIndex(of: status)!),from : right ? from! : to! , to: right ? to! : from!, context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }.navigationTitle("Edit the flow")
        .background(Color.background)
        .onAppear {
          UITableView.appearance().backgroundColor = .clear
        }
        .onDisappear {
          UITableView.appearance().backgroundColor = .systemGroupedBackground
        }
    }
}

