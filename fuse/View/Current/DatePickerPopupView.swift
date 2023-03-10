//
//  DatePickerPopupView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/22.
//

import SwiftUI

struct DatePickerPopupView: View {
    @Binding var isPresent: Bool
    @Binding var selection: Date
    var body: some View {
        
        VStack{
            DatePicker("",selection: $selection, displayedComponents: .date).datePickerStyle(GraphicalDatePickerStyle())
            Button(action: {
                            withAnimation {
                                isPresent = false
                            }
                        }, label: {
                            Text("OK")
            })
        }.frame(width: 280, alignment: .center)
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .compositingGroup()
            .shadow(color:Color(UIColor.systemBackground), radius: 30)
            
          
       
    }
}

//struct DatePickerPopupView_Previews: PreviewProvider {
//    static var previews: some View {
//        DatePickerPopupView()
//    }
//}
