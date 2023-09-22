//
//  EditChargeView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/11.
//

import SwiftUI



struct EditChargeView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    enum Field: Hashable {
            case amount
            case name
            case note
    }
    
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var capacitors: FetchedResults<Capacitor>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.createdAt, order: .reverse)]) var categories: FetchedResults<Category>
    
    
    
    var charge: FetchedResults<Charge>.Element
    
    @State private var name = ""
    @State private var amount = 100
    @State private var date = Date()
    @State private var right = true
    @State private var status = 0
    @State private var from: UUID?
    @State private var to: UUID?
    @State private var note = ""
    @State private var included = false
    @State private var is_variable = false
    @State private var category : UUID?
    
    
    @State var vfrom : UUID?
    @State var vto : UUID?
    @State var start = Date()
    @State var end = Date()
    @FocusState var focusedField: Field?
    
    @State private var showingAddCategoryView = false
    
    @State private var didAppearAlready = false
    @Binding var isButtonVisible: Bool

    
    var body: some View {
        
        List {
            Section {
                HStack {
                    
                    
                    
                
                        
                    if is_variable {
                        
                        Group{
                            NavigationLink(destination: VariableChargeView(vfrom:$vfrom, vto:$vto, start:$start, end:$end, capacitors: capacitors)){
                                
                                Text("¥   \(amount)").focused($focusedField, equals: .amount)
                            }
                        }
                        
                        
                    } else {
                        
                        Group{
                            HStack{
                                Text("¥ ")
                                TextField("Amount", value: $amount ,format: .number).keyboardType(.numberPad).focused($focusedField, equals: .amount)
                            }
                        }
                        
                        
                    }
                    
                    Picker("Is variable", selection: $is_variable) {
                        Text("Constant").tag(false)
                        Text("Variable").tag(true)
                    }.pickerStyle(SegmentedPickerStyle())
                        
                        
                    
                    
                    
                }
                TextField("Charge name", text: $name)
                    .focused($focusedField, equals: .name)
                    
                DatePicker("Date", selection: $date,displayedComponents: .date)
                .onChange(of: date){ newDate in
                    if isFutureDate(newDate) {
                        status = Status.upcoming.rawValue
                    }
                }
                
                
            }
            
            Section {
                
                Picker("Status", selection: $status) {
                    Text("Confirmed").tag(Status.confirmed.rawValue)
                    Text("Upcoming").tag(Status.upcoming.rawValue)
                    Text("Pending").tag(Status.pending.rawValue)
                    
                }
                .pickerStyle(SegmentedPickerStyle())
                if status == Status.pending.rawValue {
                    Toggle(isOn: $included) {
                        Label("Includes in the balance", systemImage: "link")
                    }
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
                
                Picker(selection: $from, label: Text("From")) {
                    
                    ForEach(capacitors, id: \.id) { capacitor in
                        Text(capacitor.name ?? "").tag(capacitor)
                    }
                }
                
                HStack{
                    Spacer()
                    Button(action: {
                        let tmp = to
                        
                        if from == srcId {
                            to = gndId
                        } else {
                            to = from
                        }
                        
                        if tmp == gndId {
                            from = srcId
                        } else {
                            from = tmp
                        }
                    }){
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                
                
                Picker(selection: $to, label: Text("To")) {
                    ForEach(capacitors, id: \.id) { capacitor in
                        Text(capacitor.name ?? "").tag(capacitor)
                    }
                }
                
                
                
                
                
            }
            
            
                
                
                
            TextEditor(text: $note).frame(height:100).focused($focusedField, equals: .note).toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()         // 右寄せにする
                    Button("Close") {
                        focusedField = nil  //  フォーカスを外す
                    }
                }
            }
            
            
        }.navigationTitle("Edit Charge")
            .onChange(of: start){ newStart in
                if is_variable {
                    amount = DataController.shared.calcAmount(start: newStart, end: end, from: vfrom!, to: vto!, context: managedObjContext)
                }
            }.onChange(of: end){ newEnd in
                if is_variable {
                    amount = DataController.shared.calcAmount(start: start, end: newEnd, from: vfrom!, to: vto!, context: managedObjContext)
                }
            }.onChange(of: vfrom){ newVfrom in
                if is_variable {
                    amount = DataController.shared.calcAmount(start: start, end: end, from: newVfrom!, to: vto!, context: managedObjContext)
                }
            }.onChange(of: vto){ newVto in
                if is_variable {
                    amount = DataController.shared.calcAmount(start: start, end: end, from: vfrom!, to: newVto!, context: managedObjContext)
                }
            }.toolbar{
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        if let from = from, let to = to, let category = category {
                            DataController.shared.editCharge(charge: charge, name: name, amount: Int32(amount), date: date, status: Int16(status), from: from, to: to, note: note, included: included, is_variable: is_variable, start: start, end: end, vfrom_id: vfrom!, vto_id: vto!, category: category,context: managedObjContext)
                        }else{
                            print("from or to is nil")
                        }
                        
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
                
                
            }.onAppear{
                isButtonVisible = false
                print("isButtonVisible", isButtonVisible)
                if !didAppearAlready {
                            
                    name = charge.name ?? ""
                    amount = Int(charge.amount)
                    date = charge.date ?? Date()
                    status = Int(charge.status)
                    from = charge.from_id ?? gndId!
                    to = charge.to_id ?? gndId!
                    note = charge.note ?? ""
                    included = charge.included
                    is_variable = charge.is_variable
                    category = charge.category?.id ?? uncatId!
                    
                    start = charge.start ?? Date()
                    end = charge.end ?? Date()
                    vfrom = charge.vfrom_id ?? gndId!
                    vto = charge.vto_id ?? gndId!
                                
                    didAppearAlready = true
                }
                
                
            }.onDisappear{
                isButtonVisible = true
                print("isButtonVisible", isButtonVisible)
            }.sheet(isPresented: $showingAddCategoryView){
                AddCategoryView(category: $category)
            }


    }
}

