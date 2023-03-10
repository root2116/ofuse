//
//  PeriodPickerView.swift
//  Fuse
//
//  Created by araragi943 on 2023/03/03.
//

import SwiftUI

struct PeriodPickerView: View {
    @Binding var every: Int
    @Binding var span: String
    @Binding var showPicker: PickerField?
    
    
    let numbers: [Int] = Array(1...100)
    let spans = ["day","week","month","year"]
    
    var body: some View {
        VStack{
            Button(action: {
                withAnimation {
                    showPicker = nil
                    
                }
                            
                        }) {
                            HStack {
                                Spacer() //右寄せにするため使用
                                Text("Done")
                                    .padding(.horizontal, 15.0)
                            }
                    }
            
            HStack{
                Picker(selection: $every, label: Text("")){
                    ForEach(numbers, id:\.self){ number in
                        Text("\(number)")
                    }
                }.frame(width: 150, height: nil)
                    .clipped()
                Picker(selection: $span, label: Text("")){
                    ForEach(spans, id:\.self){ span in
                        Text("\(span)")
                    }
                }.frame(width: 150, height: nil)
                    .clipped()
                
            }
        }
    }
}

//struct PeriodPickerView_Previews: PreviewProvider {
//    @State private var every = 2
//    @State private var span = "month"
//    @State private var showPicker = false
//    static var previews: some View {
//        PeriodPickerView(every: $every, span: self.$span, showPicker: self.$showPicker)
//    }
//}
