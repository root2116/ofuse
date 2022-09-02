//
//  AddFlowView.swift
//  fuse
//
//  Created by araragi943 on 2022/06/09.
//

import SwiftUI

import CoreData

struct AddFlowView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var capacitors: FetchedResults<Capacitor>
    
    
    
    @State private var name = ""
    @State private var amount: Int?
    @State private var date = Date()
    @State private var right = true
    @State private var status = "Confirmed"
    @State private var to = UUID(uuidString:"CE130F1C-3B2F-42CA-8339-1549531E0102")
    @State private var from : UUID?
    
   
//    @State private var to_name = "Outside"
//    @State private var from_name = ""
    let status_list = ["Confirmed", "Pending", "Uncertain"]
    
//    var capacitors_list = [String]()
    
    init(from: UUID){
//        capacitors_list = capacitors.map { capacitor in capacitor.name!}
        
//        self.to = outside_id[0].id!
        _from = State(initialValue: from)
        
        
        
    }

    
    var body: some View {
        NavigationView{
            
        
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
                    
//                    Button {
//                        isSpending.toggle()
//                        let tmp = from
//                        from = to
//                        to = tmp
//                    } label: {
//                        Label("", systemImage: isSpending ?  "minus.circle" : "plus.circle").font(.system(size: 25))
//                    }
                    
//                    Text("Amount")
//                    Divider()
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
        //                        let tmp = from
        //                        from = to
        //                        to = tmp
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
                
                
                
               
//                    .frame(width: metrics.size.width * 0.40)

//                Button {
//                    right.toggle()
////                        let tmp = from
////                        from = to
////                        to = tmp
//                } label: {
//                    Label("", systemImage: right ?  "arrow.right.square.fill" : "arrow.left.square.fill").font(.system(size: 25))
//                }.frame(width: metrics.size.width * 0.20)

               
//                    .frame(width: metrics.size.width * 0.40)
                HStack {
                    Spacer()
                    Button("Save"){
                        DataController().addFlow(name: name, amount: Int32(amount ?? 0), date: date, status: Int16(status_list.firstIndex(of: status)!), from: right ? from! : to!, to: right ? to! : from! , context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }.navigationTitle("Add a flow")
            
        }
    }
    
    private func truncateText(text: String, width: Int) -> String {
        
        var txt = text
        let font_size = UIFont.systemFontSize
        let font = UIFont.systemFont(ofSize: font_size)
        var size = text.size(with: font)
        
        let ellipsis_size = "...".size(with:font)
        var result = ""
        
        
        if Int(size.width) + Int(ellipsis_size.width) > width {
            while Int(size.width) + Int(ellipsis_size.width) > width {
                txt = String(txt.prefix(txt.count - 1))
                size = txt.size(with:font)
                
            }
            
            result = txt + "..."
        }else {
            result = txt
        }
        
        return result
        
    }
    
   

}

//struct AddFlowView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddFlowView()
//    }
//}
