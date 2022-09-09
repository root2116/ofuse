//
//  AddFlowView.swift
//  fuse
//
//  Created by araragi943 on 2022/06/09.
//

import SwiftUI
import Introspect
import CoreData

struct AddFlowView: View {
    
    
    
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var capacitors: FetchedResults<Capacitor>
    
    @FocusState private var focusedField: FlowField?
    
    @State private var name = ""
    @State private var amount: Int?
    @State private var date = Date()
    @State private var right = true
    @State private var status = 0
    @State private var to = UUID(uuidString:"CE130F1C-3B2F-42CA-8339-1549531E0102")
    @State private var from : UUID?
    @State private var note = ""
    
    @State private var isTentative = false
    @State var enable: Bool = true
//    @State private var to_name = "Outside"
//    @State private var from_name = ""
    let status_list = ["Confirmed", "Coming", "Pending"]
    
//    var capacitors_list = [String]()
    
    init(from: UUID){
//        capacitors_list = capacitors.map { capacitor in capacitor.name!}
        
//        self.to = outside_id[0].id!
        _from = State(initialValue: from)
        
        
        
    }

//    var gesture: some Gesture {
//            DragGesture()
//                .onChanged{ value in
//                    if value.translation.height != 0 {
//                        self.focusedField = nil
//                    }
//                }
//        }
    
    
    var body: some View {
        NavigationView{
            
        
        Form {
            Section {
                Picker("Status", selection: $status) {
                            Text("Confirmed").tag(Status.confirmed.rawValue)
                            Text("Coming").tag(Status.coming.rawValue)
                            Text("Pending").tag(Status.pending.rawValue)
                                    
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                
                if status == Status.pending.rawValue || status == Status.tentative.rawValue {
                    Toggle(isOn: $isTentative) {
                        Label("Includes in the balance", systemImage: "link")
                    }
                }
                TextField("Flow name", text: $name).focused($focusedField, equals: .name)
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
                
                
                
                
//                ZStack(alignment: .topLeading) {
//                    TextEditor(text: $note)
//                        .frame(height: 120)
//                        .padding()
//                        .focused($focusedField, equals: .note)
////                        .ignoresSafeArea(.keyboard, edges: .bottom)
//                    if note.isEmpty {
//                        Text("Type something...")
//                            .foregroundColor(Color(uiColor: .placeholderText))
//                            .allowsHitTesting(false)
//                            .padding(20)
//                            .padding(.top, 5)
//                    }
//                }.ignoresSafeArea(.container, edges: .bottom)
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
                        enable = false
                        DataController().addFlow(name: name, amount: Int32(amount ?? 0), date: date, status: Int16((isTentative && status == Status.pending.rawValue) ? Status.tentative.rawValue : status) , from: right ? from! : to!, to: right ? to! : from! , note: note, context: managedObjContext)
                        dismiss()
                    }.disabled(!enable)
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
