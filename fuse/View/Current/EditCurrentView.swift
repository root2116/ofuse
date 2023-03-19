//
//  AddCurrentView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/18.
//

import SwiftUI




struct EditCurrentView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    
    @FocusState private var focusedField: CurrentField?
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var capacitors: FetchedResults<Capacitor>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var categories: FetchedResults<Category>
    
    var current: FetchedResults<Current>.Element
    
    @State private var name = ""
    @State private var amount: Int?
    @State private var next = Date()
    @State private var is_variable = false
    @State private var category : UUID?
    
    @State var vfrom = gndId
    @State var vto = gndId
    @State var start = Date()
    @State var end = Date()

   
    @State private var to = gndId
    @State private var from = gndId
    
    @State private var showPeriodPicker = false
    @State private var showWeekdayPicker = false
    @State private var showDayPicker = false
    @State private var showMonthDayPicker = false
    @State private var showPicker : PickerField? = nil
    
    @State private var showingAddCategoryView = false
    
    @State private var every: Int = 1
    @State private var span = "month"
    @State private var on_day : Int = Calendar.current.component(.day, from: Date())
    @State private var on_weekday : Int = Calendar.current.component(.weekday, from: Date()) - 1
    @State private var on_month: Int = Calendar.current.component(.month, from: Date())
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
        
            VStack{
                List {
                    
                    
                    
                    Section {
                        
                        HStack{
                            Text("¥ ")
                            TextField("Amount", value: $amount,format: .number).keyboardType(.numberPad).focused($focusedField, equals: .amount)
                                .onTapGesture {
                                    showPicker = nil
                                }
                        }
                        
                        
                        TextField("Current name", text: $name)
                            .focused($focusedField, equals: .name)
                            .onAppear{
                                
                                
                                name = current.name ?? ""
                                amount = Int(current.amount)
                                every = Int(current.every)
                                span = current.span ?? ""
                                on_weekday = Int(current.weekday)
                                on_day = Int(current.day)
                                on_month = Int(current.month)
                                next = current.next ?? Date()
                                from = current.from_id ?? gndId
                                to = current.to_id ?? gndId
                                category = current.category?.id ?? uncatId!
                                
                            }.onTapGesture {
                                showPicker = nil
                            }
                        
                            Picker(selection: $category, label: Text("Category")){
                                ForEach(categories, id: \.id) { category in
                                    Text(category.name ?? "").tag(category.id)

                                }

                                Text("New Category...").tag(newId)
                            }.onChange(of: category) { value in
                                if value == newId {
                                    showingAddCategoryView = true
                                }
                            }
                        
                        
                        
                        
                    }
                    
                   
                    Section{
                        
                        Button(action: {
                            withAnimation{
                                
                                showPicker = PickerField.period
                                focusedField = nil
                            }
                            
                            
                        },
                               label:{
                            HStack{
                                
                                
                                if every == 1 {
                                    Text("Every \(span)")
                                } else {
                                    Text("Every \(every) \(span)s")
                                }
                            }
                        }
                        ).focused($focusedField, equals: .period)
                        
                        
                        if span != "day" {
                            Button(action: {
                                
                                focusedField = nil
                                withAnimation{
                                    if span == "week" {
                                        showPicker = PickerField.weekday
                                    } else if span == "month" {
                                        showPicker = PickerField.day
                                    } else if span == "year" {
                                        showPicker = PickerField.monthday
                                    }
                                    
                                }
                                
                            }, label: {
                                if span == "week" {
                                    Text("On \(weekday_list[on_weekday])")
                                } else if span == "month" {
                                    Text("On the \(day_list[on_day]) day")
                                } else if span == "year" {
                                    Text("On \(month_list[on_month-1]) \(day_list[on_day])")
                                }
                                
                            }).focused($focusedField, equals: .day)
                        }
                        
                        
                        
                        DatePicker("Next to generate", selection: $next,displayedComponents: .date)
                            .onTapGesture {
                                showPicker = nil
                            }
                        
                        
                    }
                    
                    
                    Section {
                        Picker(selection: $from, label: Text("From")) {
                            
                            ForEach(capacitors, id: \.id) { capacitor in
                                Text(capacitor.name ?? "").tag(capacitor)
                            }
                        }.onAppear{
                            if let cap = DataController.shared.getOneCapacitor(context: managedObjContext) {
                                from = cap
                            } else {
                                from = gndId
                            }
                        }
                        
                        HStack{
                            Spacer()
                            Button(action: {
                                if showPicker == nil {
                                    let tmp = to
                                    to = from
                                    from = tmp
                                }
                               
                            }){
                                Image(systemName: "arrow.up.arrow.down").padding(.horizontal, 30.0)
                            }
                        }
                        
                        
                        Picker(selection: $to, label: Text("To")) {
                            ForEach(capacitors, id: \.id) { capacitor in
                                Text(capacitor.name ?? "").tag(capacitor)
                            }
                        }
                        
                    }
                    
                }
                }.navigationTitle("Edit Current")
                .background(Color.background)
                .toolbar{
                    
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button {
                            DataController.shared.editCurrent(current: current, name: name, amount: Int32(amount ?? 0), from: from ?? gndId!, to: to ?? gndId!, every: Int16(every), span: span, day: Int16(on_day), month: Int16(on_month), weekday: Int16(on_weekday), next: next, category: category ?? uncatId!, context: managedObjContext)
                            
                            dismiss()
                        } label: {
                            Text("Done")
                        }
                    }
                }
//                .onAppear {
//                  UITableView.appearance().backgroundColor = .clear
//                }
//                .onDisappear {
//                  UITableView.appearance().backgroundColor = .systemGroupedBackground
//                }
            
            
        
        
            
        
        if showPicker == PickerField.period {
            PeriodPickerView(every: $every, span: $span, showPicker: $showPicker)
                .pickerStyle(WheelPickerStyle()).offset(y: showPicker == PickerField.period ? 0 : UIScreen.main.bounds.height)
        } else if showPicker == PickerField.weekday {
            WeekdayPickerView(on_weekday: $on_weekday, showPicker: $showPicker)
                .pickerStyle(WheelPickerStyle()).offset(y: showPicker == PickerField.weekday ? 0 : UIScreen.main.bounds.height)
        } else if showPicker == PickerField.day {
            DayPickerView(on_day: $on_day, showPicker: $showPicker)
                .pickerStyle(WheelPickerStyle()).offset(y: showPicker == PickerField.day ? 0 : UIScreen.main.bounds.height)
        } else if showPicker == PickerField.monthday {
            MonthDayPickerView(on_day: $on_day, on_month: $on_month, showPicker: $showPicker)
                .pickerStyle(WheelPickerStyle()).offset(y: showPicker == PickerField.monthday ? 0 : UIScreen.main.bounds.height)
        }
    }
    
}

