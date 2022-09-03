//
//  EditCapacitorView.swift
//  Fuse
//
//  Created by araragi943 on 2022/09/03.
//

import SwiftUI

struct EditCapacitorView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var capacitor: Capacitor
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var capacitors: FetchedResults<Capacitor>
    
    @State private var opened = false
    
    
    @State private var name = ""
    @State private var init_balance: Int?
    @State private var type = 0

    @State private var settlement = 1
    @State private var payment = 1
    @State private var from = UUID(uuidString: "CE130F1C-3B2F-42CA-8339-1549531E0102")
    
    @State private var enable: Bool = true
    
    let days: [Int] = Array(0...31)
    let day_list = ["last"] + Array(1...30).map {
        
        if $0 >= 11 && $0 <= 13 {
            return String($0) + "th"
        }
        

        if $0 % 10 == 1 {
            return String($0) + "st"
        } else if $0 % 10 == 2 {
            return String($0) + "nd"
        } else if $0 % 10 == 3 {
            return String($0) + "rd"
        } else {
            return String($0) + "th"
        }
    } + ["last"]
    
    var body: some View {
        NavigationView{
            
        
        Form {
            Section {
                Picker("Capacitor type", selection: $type){
                    Text("Cash").tag(0)
                    Text("Bank").tag(1)
                    Text("Card").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                .onAppear{
                    if opened == false {
                        type = Int(capacitor.type)
                        name = capacitor.name!
                        init_balance = Int(capacitor.init_balance)
                        settlement = Int(capacitor.settlement)
                        payment = Int(capacitor.payment)
                        if capacitor.payment_conductor != nil {
                            from = capacitor.payment_conductor!.from_id
                        }
                        
                        opened = true
                        
                    }
                }
                
                TextField("Capacitor name", text: $name)
                HStack{
                    Text("¥ ")
                    TextField("Init balance", value: $init_balance,format: .number).keyboardType(.numberPad)
                        
                    
                    
                }
               
                
                if type == 2 {
                    
                    NavigationLink(destination: Picker("Settlement Picker", selection: $settlement) {
                        ForEach(days, id:\.self){ index in
                            Text(day_list[index])

                        }
                    }.pickerStyle(WheelPickerStyle())){
                        Text("Settlement")
                        Spacer()
                        Text("\(day_list[settlement])")
                    }
                    
                    NavigationLink(destination: Picker("Payment Picker", selection: $payment) {
                        ForEach(days, id:\.self){ index in
                            Text(day_list[index])

                        }
                    }.pickerStyle(WheelPickerStyle())){
                        Text("Payment")
                        Spacer()
                        Text("\(day_list[payment])")
                    }
                    
                    HStack{
                        Text("From")
                        Spacer()
                        Menu(getName(items:capacitors,id: from!)) {
                            Picker("From Capacitor",selection: $from){
                                ForEach(capacitors, id: \.id){ cap in
                                    Text(cap.name!)
                                }
                            }
                            
                        }
                    }
                    
                }
                
             
                
                HStack {
                    Spacer()
                    Button("Save"){
                        enable = false
                        DataController().editCapacitor(capacitor: capacitor, name: name, init_balance: Int32(init_balance ?? 0), type: Int16(type), settlement: Int16(settlement), payment: Int16(payment), from: from!, context: managedObjContext)
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
