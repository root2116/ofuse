//
//  PeriodPickerView.swift
//  Fuse
//
//  Created by araragi943 on 2023/03/03.
//

import SwiftUI

struct MonthDayPickerView: View {
    @Binding var on_day: Int
    @Binding var on_month: Int
    @Binding var showPicker: PickerField?
    
    let months: [Int] = Array(1...12)
    let month_list =  ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
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
                Picker(selection: $on_month, label: Text("")){
                    ForEach(months, id:\.self){ month in
                        Text("\(month_list[month-1])")
                    }
                }.frame(width: 150, height: nil)
                    .clipped()
                Picker(selection: $on_day, label: Text("")){
                    ForEach(days, id:\.self){ day in
                        Text("\(day_list[day])")
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
