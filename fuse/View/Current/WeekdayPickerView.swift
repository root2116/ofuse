//
//  PeriodPickerView.swift
//  Fuse
//
//  Created by araragi943 on 2023/03/03.
//

import SwiftUI

struct WeekdayPickerView: View {
    @Binding var on_weekday: Int
    @Binding var showPicker: PickerField?
    
    
    let weekdays: [Int] = Array(0...6)
    let weekday_list = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    
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
                Picker(selection: $on_weekday, label: Text("")){
                    ForEach(weekdays, id:\.self){ weekday in
                        Text("\(weekday_list[weekday])")
                    }
                }
                
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
