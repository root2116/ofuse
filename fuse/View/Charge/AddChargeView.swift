//
//  AddChargeView.swift
//  fuse
//
//  Created by araragi943 on 2022/06/09.
//

import SwiftUI
import CoreData



struct AddChargeView: View {
    
    
    var openedCapId : UUID
    
    enum Field: Hashable {
            case amount
            case name
            case note
    }
    
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    
    
    let dateFilter: Date = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy, hh:mm:ss.SSS a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: "03/20/2023, 05:20:10.000 AM") ?? Date()
    }()

    
    @FetchRequest var capacitors: FetchedResults<Capacitor>
    
    
    
    @FetchRequest var categories: FetchedResults<Category>
    
    
    init(openedCapId: UUID){
        self.openedCapId = openedCapId
        
        self._capacitors = FetchRequest<Capacitor>(
                                sortDescriptors: [
                                    SortDescriptor(\.createdAt, order: .reverse)
           
                                ],
                                predicate: NSPredicate(format: "createdAt >= %@", dateFilter as NSDate),
                                animation: nil)
        
        self._categories = FetchRequest<Category>(
                            sortDescriptors: [
                                SortDescriptor(\.createdAt, order: .reverse)

                            ],
                            animation: nil)
    }
    
//    @FocusState private var focusedField: ChargeField?
    @State private var is_variable = false
    @State private var name = ""
    @State private var amount: Int?
    @State private var date = Date()
    @State private var right = true
    @State private var status = 0
    @State private var category : UUID?
    
//    @AppStorage("from") var from: UUID?
//    @AppStorage("to") var to: UUID?
    
    @State private var from : UUID?
    @State private var to: UUID?
    
    @State var vfrom = gndId
    @State var vto = gndId
    @State var start = Date()
    @State var end = Date()
    
    @State private var note = ""
    
    @State private var included = false
    @State var enable: Bool = true
    

    @FocusState var focusedField: Field?

    
    @State private var showingAddCategoryView = false
    

    
 
    var body: some View {
        NavigationView{
            
            
                
                 
                        List {
                            Section {
                                HStack {
                                    
                                    
                                    
                                    
                                    if is_variable {
                                        
                                        Group{
                                            NavigationLink(destination: VariableChargeView(vfrom:$vfrom, vto:$vto, start:$start, end:$end, capacitors: capacitors)){
                                                
                                                Text("¥   \(amount ?? 0)").focused($focusedField, equals: .amount)
                                            }
                                        }
                                        
                                        
                                    } else {
                                        
                                        Group{
                                            HStack{
                                                Text("¥ ")
                                                TextField("Amount", value: $amount,format: .number).keyboardType(.numberPad).focused($focusedField, equals: .amount)
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
                            
                            Section{
                                
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
                                }.onAppear{
                                   let cat = DataController.shared.fetchUncategorized(context: managedObjContext)
                                    category = cat.id!
                                }
                            }
                            
                            
                            Section{
                                
                                Picker(selection: $from, label: Text("From")) {
                                    
                                    
                                    ForEach(capacitors, id: \.id) { capacitor in
                                        Text(capacitor.name ?? "").tag(capacitor)
                                    }
                                }.onAppear{
                                    
                                    from = openedCapId
                                    
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
                                }.onAppear{
                                    
                                    to = gndId
                                    
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
                            
                            
                        }.navigationTitle("New Charge")
                            .onChange(of: start){ newStart in
                                amount = DataController.shared.calcAmount(start: newStart, end: end, from: vfrom!, to: vto!, context: managedObjContext)
                            }.onChange(of: end){ newEnd in
                                amount = DataController.shared.calcAmount(start: start, end: newEnd, from: vfrom!, to: vto!, context: managedObjContext)
                            }.onChange(of: vfrom){ newVfrom in
                                amount = DataController.shared.calcAmount(start: start, end: end, from: newVfrom!, to: vto!, context: managedObjContext)
                            }.onChange(of: vto){ newVto in
                                amount = DataController.shared.calcAmount(start: start, end: end, from: vfrom!, to: newVto!, context: managedObjContext)
                            }.toolbar{
                                
                                ToolbarItem(placement: .navigationBarTrailing){
                                    Button {
                                        if let from = from, let to = to, let category = category {
                                            let _ = DataController.shared.addCharge(name: name, amount: Int32(amount ?? 0), date: date, status: Int16(status), from: from, to: to, note: note, included: included, is_variable: is_variable, start: start, end: end, vfrom_id: vfrom!, vto_id: vto!, category: category,  context: managedObjContext)
                                        }else{
                                            print("from or to is nil")
                                        }
                                        
                                        dismiss()
                                    } label: {
                                        Text("Add")
                                    }
                                }
                                ToolbarItem(placement: .navigationBarLeading){
                                    Button {
                                        dismiss()
                                    } label: {
                                        Text("Cancel")
                                    }
                                }
                                
                            }.sheet(isPresented: $showingAddCategoryView){
                                AddCategoryView(category: $category)
                            }
            
            
                        
                        
                        
                    
                
            
        }
    }
    
    private func truncateText(text: String, width: Int) -> String {
        
        var txt = text
        let font_size = UIFont.systemFontSize
        let font = UIFont.systemFont(ofSize: font_size)
        var size = text.size(with: font)
        
        let ellipsis_size = "...".size(with:font)
        var result = ""
        
        
        if Int(size.width) + Int(ellipsis_size.width) > width {
            while Int(size.width) + Int(ellipsis_size.width) > width {
                txt = String(txt.prefix(txt.count - 1))
                size = txt.size(with:font)
                
            }
            
            result = txt + "..."
        }else {
            result = txt
        }
        
        return result
        
    }
    
//
//    private func amountView() -> some View{
//
//    }
//
//

}

//struct AddChargeView_Previews: PreviewProvider {
//    static let context = DataController.shared.container.viewContext
//
//    static var previews: some View {
//
//
//        AddChargeView().environment(\.managedObjectContext, context)
////            .environment(\.gndId, gndId!).environment(\.srcId, srcId!)
//    }
//}


extension UUID: RawRepresentable {
    public var rawValue: String {
        self.uuidString
    }

    public typealias RawValue = String

    public init?(rawValue: RawValue) {
        self.init(uuidString: rawValue)
    }
}

extension Array where Element: Capacitor {
    var uniqueByName: [Element] {
        return self.reduce(into: [Element]()) { (result, capacitor) in
            if !result.contains(where: { $0.name == capacitor.name }) {
                result.append(capacitor)
            }
        }
    }
}

