//
//  EditFlowView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/11.
//

import SwiftUI
import Introspect

enum FlowField: Hashable {
    case name
    case amount
    case note
}

struct EditFlowView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focusedField: FlowField?
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var capacitors: FetchedResults<Capacitor>
    
    var flow: FetchedResults<Flow>.Element
    
    @State private var name = ""
    @State private var amount = 0
    @State private var date = Date()
    @State private var right = true
    @State private var status = 0
    @State private var from: UUID? = UUID()
    @State private var to: UUID? = UUID()
    @State private var note = ""
    
    @State private var isTentative = false
    
    let status_list = ["Confirmed", "Pending", "Uncertain"]
    
    
    var gesture: some Gesture {
            DragGesture()
                .onChanged{ value in
                    if value.translation.height != 0 {
                        self.focusedField = nil
                    }
                }
        }
    
    
    var body: some View {
        Form {
            Section {
                Picker("Status", selection: $status) {
                    Text("Confirmed").tag(Status.confirmed.rawValue)
                    Text("Pending").tag(Status.pending.rawValue)
                    Text("Uncertain").tag(Status.uncertain.rawValue)
                                    
                                       
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .onAppear{
                                        name = flow.name!
                                        amount = Int(flow.amount)
                                        date = flow.date!
                                        
                                        if flow.status == Status.tentative.rawValue {
                                            status = Status.uncertain.rawValue
//                                            status_list[Status.uncertain.rawValue]
                                            isTentative = true
                                        } else {
//                                            status = status_list[Int(flow.status)]
                                            status = Int(flow.status)
                                        }
                                        
                                        from = flow.from!.id!
                                        to = flow.to!.id!
                                        note = flow.note ?? ""
                                    }
                
                if status == Status.uncertain.rawValue {
                    
                    Toggle(isOn: $isTentative) {
                        Label("Included in the balance", systemImage: "link")
                    }
                }
                TextField("Flow name",text: $name).focused($focusedField, equals: .name)
                    
                
                
                HStack{
                   
                    Text("¥ ")
                    TextField("Amount", value: $amount,format: .number).keyboardType(.numberPad).focused($focusedField, equals: .amount)
                    
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
                
                TextEditor(text: $note)
                    .introspectTextView { textView in
                            textView.isScrollEnabled = false
                        }
                    .frame(height: 120)
                    .focused($focusedField, equals: .note)
                    .toolbar {
                                      ToolbarItemGroup(placement: .keyboard) {
                                          Spacer()         // 右寄せにする
                                          Button("Close") {
                                              focusedField = nil  //  フォーカスを外す
                                          }
                                      }
                                  }
                    
                
                
                HStack{
                    Spacer()
                    Button("Save"){
                        DataController().editFlow(flow: flow, name: name, amount: Int32(amount), date: date, status: Int16((isTentative && status == Status.uncertain.rawValue) ? Status.tentative.rawValue : status) ,from : right ? from! : to! , to: right ? to! : from!, note: note, context: managedObjContext)
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

