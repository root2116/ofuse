//
//  VariableChargeView.swift
//  Fuse
//
//  Created by araragi943 on 2023/03/01.
//

import SwiftUI

struct VariableChargeView: View {
    @Binding var vfrom : UUID?
    @Binding var vto : UUID?
    @Binding var start : Date
    @Binding var end : Date
    
    var capacitors : FetchedResults<Capacitor>
    
    var body: some View {
        
        Form{
            Section{
                Picker(selection: $vfrom, label: Text("From")) {
                    ForEach(capacitors, id: \.id) { capacitor in
                        Text(capacitor.name ?? "").tag(capacitor)
                    }
                }
                Picker(selection: $vto, label: Text("To")) {
                    ForEach(capacitors, id: \.id) { capacitor in
                        Text(capacitor.name ?? "").tag(capacitor)
                    }
                }
                
                DatePicker("Start", selection: $start,displayedComponents: .date)
                
                DatePicker("End", selection: $end,displayedComponents: .date)
                
                
            }
        }
    }
}

//struct VariableChargeView_Previews: PreviewProvider {
//    static var previews: some View {
//        VariableChargeView()
//    }
//}
