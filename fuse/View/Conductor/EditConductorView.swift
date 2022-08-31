//
//  AddConductorView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/18.
//

import SwiftUI

struct EditConductorView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var capacitors: FetchedResults<Capacitor>
    
    var conductor: FetchedResults<Conductor>.Element
    
    @State private var showingPopUp = false
    
    @State private var name = ""
    @State private var amount = 0
    @State private var day : Int16 = 0
    @State private var month : Int16 = 0
    @State private var weekday: Int16 = 0
    
    @State private var day_buffer : Int16 = 0
    @State private var month_buffer : Int16 = 0
    @State private var weekday_buffer : Int16 = 0
    
    @State private var next = Date()
    @State private var category = "Uncategorized"
    @State private var right = true
    @State private var to: UUID? = UUID()
    @State private var from: UUID? = UUID()
    
    @State private var every: Int = 1
    @State private var span = "day"
    @State private var on_day : Int = Calendar.current.component(.day, from: Date())
    @State private var on_weekday : Int = Calendar.current.component(.weekday, from: Date()) - 1
    @State private var on_month: Int = Calendar.current.component(.month, from: Date())
    
    @State private var opened = false
    @State private var filled = false
//    @State private var on_year_month: Int = 0
//    @State private var on_year_day: Int = 0
    
    @State var spans = ["day","week","month","year"]
    
    
 
    let days: [Int] = Array(0...31)
    let months: [Int] = Array(0...11)
    let weekdays: [Int] = Array(0...6)
    let month_list =  ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
//    let weekday_list = ["*","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    
    
    let weekday_list = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
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
    
    
    
    let numbers: [Int] = Array(1...100)
    
    
    
    
    var body: some View {
        ZStack(alignment: .top){
            
        
           
            
                
                Form {
                    
                        
                    
                    Section {
                        
                        TextField("Conductor name", text: $name)
                            .onAppear{
                                
                                if opened == false {
                                    name = conductor.name!
                                    amount = Int(conductor.amount)
                                    every = Int(conductor.every)
                                    span = conductor.span!
                                    on_weekday = Int(conductor.weekday)
                                    on_day = Int(conductor.day)
                                    on_month = Int(conductor.month)
                                    next = conductor.next!
                                    from = conductor.from_id!
                                    to = conductor.to_id!
                                    category = conductor.category!
                                    opened = true
                                }
                                
                            }
                        HStack{
                            Text("¥ ")
                            TextField("Amount", value: $amount,format: .number).keyboardType(.numberPad)
                        }
                        
                        NavigationLink(destination: HStack {
                            
                            Picker("Value Picker", selection: $every) {
                                ForEach(numbers,id:\.self){ number in
                                    Text("\(number)").scaleEffect(x: 2.0)
                                    
                                }
                            }.pickerStyle(WheelPickerStyle()).frame(width: 150).contentShape(Rectangle()).compositingGroup().scaleEffect(x: 0.5)
                    
                            
                            
                            Picker("Kind Picker", selection: $span) {
                                ForEach(spans,id: \.self){ span in


                                    if(every >= 2){
                                        Text("\(span)s").scaleEffect(x: 2.0)
                                    }else {
                                        Text("\(span)").scaleEffect(x: 2.0)
                                    }
                                }
                            }.pickerStyle(WheelPickerStyle()).frame(width: 150).compositingGroup().scaleEffect(x: 0.5)

                           
                            
                        }){
                            Text("Every")
                            Spacer()
                            
                            if every == 1 {
                                Text("\(span)")
                            } else {
                                Text("\(every) \(span)s")
                            }
                           
                            
                        }
                        
                        
                        
        //
                            
                        
                        if span != "day" {
                            
                            
                            NavigationLink(destination: HStack {
                                if span == "week" {
                                    Picker("Weekday Picker", selection: $on_weekday) {
                                        ForEach(weekdays, id:\.self){ index in
                                            Text(weekday_list[index])

                                        }
                                    }.pickerStyle(WheelPickerStyle())

                                } else if span == "month" {
                                    Picker("Month Picker", selection: $on_day){
                                        ForEach(days, id:\.self){ index in
                                            Text("\(day_list[index])")
                                            
                                        }
                                    }.pickerStyle(WheelPickerStyle())
                                } else if span == "year" {
                                    Picker("Month Picker", selection: $on_month) {
                                        ForEach(months,id:\.self){ index in
                                            Text("\(month_list[index])").scaleEffect(x: 2.0)
                                            
                                        }
                                    }.pickerStyle(WheelPickerStyle()).frame(width: 150).contentShape(Rectangle()).compositingGroup().scaleEffect(x: 0.5)
                            
                                    
                                    
                                    Picker("Day Picker", selection: $on_day) {
                                        ForEach(days,id: \.self){ index in

                                            Text("\(day_list[index])").scaleEffect(x: 2.0)
                                            
                                        }
                                    }.pickerStyle(WheelPickerStyle()).frame(width: 150).compositingGroup().scaleEffect(x: 0.5)

                                   
                                }
                                
                                
        //                        Picker("Value Picker", selection: $every) {
        //                            ForEach(numbers,id:\.self){ number in
        //                                Text("\(number)").scaleEffect(x: 2.0)
        //
        //                            }
        //                        }.pickerStyle(WheelPickerStyle()).frame(width: 150).contentShape(Rectangle()).compositingGroup().scaleEffect(x: 0.5)
        //
        //
        //
        //                        Picker("Kind Picker", selection: $span) {
        //                            ForEach(spans,id: \.self){ span in
        //
        //
        //                                if(every >= 2){
        //                                    Text("\(span)s").scaleEffect(x: 2.0)
        //                                }else {
        //                                    Text("\(span)").scaleEffect(x: 2.0)
        //                                }
        //                            }
        //                        }.pickerStyle(WheelPickerStyle()).frame(width: 150).compositingGroup().scaleEffect(x: 0.5)
        //
        //
        //
                            }){
                                Text("On")
                                Spacer()

                                if span == "week" {
                                    Text("\(weekday_list[on_weekday])")
                                } else if span == "month" {
                                    Text("\(day_list[on_day]) day")
                                } else if span == "year" {
                                    Text("\(month_list[on_month]) \(day_list[on_day])")
                                }
                               
                            }

                            
                            
                        }
                        
                        

                        HStack{
                            Text("Next")
                            Spacer()
                           
                            Button(action: {
                                            withAnimation {
                                                showingPopUp = true
                                            }
                                        }, label: {
                                            
                                            
                                            Text(formatDate(date: next))
                                              
                                        })
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
                        
                        HStack{
                            Text("To")
                            Spacer()
                            Menu(getName(items:capacitors,id: to!)) {
                                Picker("To Capacitor",selection: $to){
                                    ForEach(capacitors, id: \.id){ cap in
                                        Text(cap.name!)
                                    }
                                }
                            }
                        }
//                        GeometryReader { metrics in
//
//
//                                HStack(alignment: .center) {
//                                    Menu(getName(items:capacitors,id: from!)) {
//                                        Picker("From Capacitor",selection: $from){
//                                            ForEach(capacitors, id: \.id){ cap in
//                                                Text(cap.name!)
//                                            }
//                                        }
//
//                                    }.frame(width:metrics.size.width * 0.40)
//
//
//                                    Button {
//                                        right.toggle()
//                //                        let tmp = from
//                //                        from = to
//                //                        to = tmp
//                                    } label: {
//                                        Label("", systemImage: right ?  "arrow.right.square.fill" : "arrow.left.square.fill").font(.system(size: 25))
//                                    }.frame(width: metrics.size.width * 0.20)
//
//                                    Menu(getName(items:capacitors,id: to!)) {
//                                        Picker("To Capacitor",selection: $to){
//                                            ForEach(capacitors, id: \.id){ cap in
//                                                Text(cap.name!)
//                                            }
//                                        }
//                                    }.frame(width:metrics.size.width * 0.40)
//
//                                }.frame(width:metrics.size.width, height: metrics.size.height, alignment: .center)
//
//
//                        }
//
                        
                        HStack{
                            Text("Category")
                            Spacer()
                            CategoriesView(selection: $category)
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
                        HStack{
                            Spacer()
                            Button("Save"){
                                DataController().editConductor(conductor: conductor, name: name, amount: Int32(amount), from: right ? from! : to!, to: right ? to! : from! ,every: Int16(every), span: span, day: Int16(day), month: Int16(month), weekday: Int16(weekday), category: category, next: next, context: managedObjContext)
                                dismiss()
                            }
                            Spacer()
                        }
                    }.onChange(of: every){ newValue in
                        if filled {
                            
                            next = tempNext(every: newValue, span: span, on_day: on_day, on_month: on_month, on_weekday: on_weekday)
                        }
                        
                        
                        
                    }.onChange(of: span){ newValue in
                        if filled {
                            next = tempNext(every: every, span: newValue, on_day: on_day, on_month: on_month, on_weekday: on_weekday)
                        }
                        
                    }.onChange(of: on_day){ newValue in
                        if filled {
                            next = tempNext(every: every, span: span, on_day: newValue, on_month: on_month, on_weekday: on_weekday)
                        }
                        
                    }.onChange(of: on_month){ newValue in
                        if filled {
                            next = tempNext(every: every, span: span, on_day: on_day, on_month: newValue, on_weekday: on_weekday)
                        }
                        
                    }.onChange(of: on_weekday){ newValue in
                        if filled {
                            next = tempNext(every: every, span: span, on_day: on_day, on_month: on_month, on_weekday: newValue)
                        }
                        filled = true
                       
                    }
                    
                }.navigationTitle("Edit the conductor").zIndex(1)
            
            
            
            if showingPopUp {
                
                DatePickerPopupView(isPresent:$showingPopUp, selection: $next).zIndex(3)
                
            }
        
        
            
        }
    }
    
}

