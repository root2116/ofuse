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
    
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var capacitors: FetchedResults<Capacitor>
    
    
    @State private var name = ""
    @State private var init_balance = 0
    @State private var type = 0

    @State private var settlement = 1
    @State private var payment = 1
    @State private var from = UUID(uuidString: "CE130F1C-3B2F-42CA-8339-1549531E0102")
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
                
                TextField("Capacitor name", text: $name)
                HStack{
                    Text("Init balance:  ")
                    TextField("\(Int(init_balance))", value: $init_balance, formatter: NumberFormatter()).keyboardType(.numberPad)
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
                        DataController().addCapacitor(name: name, init_balance: Int32(init_balance), type: Int16(type), settlement: Int16(settlement), payment: Int16(payment), from: from!, context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }.navigationTitle("Add a capacitor")
            
        }
    }
        
        
}

struct AddCapacitorView_Previews: PreviewProvider {
    static var previews: some View {
        AddCapacitorView()
    }
}