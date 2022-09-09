//
//  CapacitorView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/13.
//

import SwiftUI



struct CapacitorView: View {
    
    
    @Environment(\.managedObjectContext) var managedObjContext
    

    @SectionedFetchRequest<String, Flow> var flowSections : SectionedFetchResults<String, Flow>
    
    var capacitor_id : UUID
    var capacitor_name : String
    var init_balance: Int
    init(capacitor_id: UUID, capacitor_name: String, init_balance: Int32 ){
        self.capacitor_id = capacitor_id
        self.capacitor_name = capacitor_name
        self.init_balance = Int(init_balance)
        
        self._flowSections = SectionedFetchRequest<String,Flow>(
                                sectionIdentifier: \.dateText,
                                sortDescriptors: [
                                    SortDescriptor(\.date, order: .reverse),
                                    SortDescriptor(\.createdAt, order: .reverse)
                                
                                ],
                                predicate: NSPredicate(format: "from_id == %@ || to_id == %@", capacitor_id as CVarArg, capacitor_id as CVarArg ),
                                animation: nil)
        
    }


    @State private var showingAddView = false
   
    
    @State private var selectionValues: Set<Flow> = []
    
    @State private var sum: Int = 0
    @Environment(\.editMode) var editMode
    
    
    
    var body: some View {
        
        
            VStack(alignment: .leading) {
                Text("Current balance: \(currentBalance()) yen")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                if editMode?.wrappedValue.isEditing == true {
                    Text("Sum: \(sumFlows(flows:selectionValues)) yen")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                List(selection: $selectionValues) {
                    
                    ForEach(flowSections){ section in
                        Section(section.id) {
                            ForEach(section, id: \.self) { flowEntry in
                                
                                if flowEntry.status == Status.pending.rawValue {
                                    FlowView(flow: flowEntry, capacitor_id: capacitor_id, balance: balance_of_the_day(flow: flowEntry,date: flowEntry.date!))
                                        .swipeActions(edge: .leading) {
                                        Button {
                                            DataController().togglePending(flow: flowEntry, context: managedObjContext)
                                        } label: {
                                            Image(systemName: "link")
                                        }.tint(.cyan)
                                    
                                        }.swipeActions(edge: .trailing){
                                            Button(role: .destructive) {
                                                
//                                                capacitorToDelete = capacitor
//                                                showingDeleteAlert = true
                                                self.deleteFlow(flow: flowEntry)
                                            } label: {
                                                Image(systemName: "trash.fill")
                                            }
                                        }
                                } else if flowEntry.status == Status.tentative.rawValue {
                                    FlowView(flow: flowEntry, capacitor_id: capacitor_id, balance: balance_of_the_day(flow: flowEntry,date: flowEntry.date!))
                                        .swipeActions(edge: .leading) {
                                        Button {
                                            DataController().togglePending(flow: flowEntry, context: managedObjContext)
                                        } label: {
                                            Image(systemName: "questionmark")
                                        }.tint(.gray)
                                        }.swipeActions(edge: .trailing){
                                            Button(role: .destructive) {
                                                
//                                                capacitorToDelete = capacitor
//                                                showingDeleteAlert = true
                                                self.deleteFlow(flow: flowEntry)
                                            } label: {
                                                Image(systemName: "trash.fill")
                                            }
                                        }
                                    
                                } else if flowEntry.status == Status.coming.rawValue {
                                    FlowView(flow: flowEntry, capacitor_id: capacitor_id, balance: balance_of_the_day(flow: flowEntry,date: flowEntry.date!))
                                        .swipeActions(edge: .leading) {
                                        Button {
                                            DataController().toggleComing(flow: flowEntry, context: managedObjContext)
                                        } label: {
                                            Image(systemName: "checkmark")
                                        }.tint(.green)
                                    
                                        }
                                        .swipeActions(edge: .trailing){
                                        Button(role: .destructive) {
                                            
//                                                capacitorToDelete = capacitor
//                                                showingDeleteAlert = true
                                            self.deleteFlow(flow: flowEntry)
                                        } label: {
                                            Image(systemName: "trash.fill")
                                        }
                                    }
                                } else {
                                    FlowView(flow: flowEntry, capacitor_id: capacitor_id, balance: balance_of_the_day(flow: flowEntry,date: flowEntry.date!))
                                        .swipeActions(edge: .leading) {
                                        Button {
                                            DataController().toggleComing(flow: flowEntry, context: managedObjContext)
                                        } label: {
                                            Image(systemName: "hourglass")
                                        }.tint(.orange)
                                    
                                        }
                                        .swipeActions(edge: .trailing){
                                        Button(role: .destructive) {
                                            
//                                                capacitorToDelete = capacitor
//                                                showingDeleteAlert = true
                                            self.deleteFlow(flow: flowEntry)
                                        } label: {
                                            Image(systemName: "trash.fill")
                                        }
                                    }
                                }
                                    
                                
                            }
//                            .onDelete {
//
//                                self.deleteFlow(at: $0, in: section)
//                            }
                        }
                    }.listRowBackground(Color.background)
                }
                .listStyle(.plain).background(Color.background)
                
            }
            .navigationTitle(self.capacitor_name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    
                    
                    Button(action: {
                        withAnimation() {
                            if editMode?.wrappedValue.isEditing == true {
                                editMode?.wrappedValue = .inactive
                            } else {
                                editMode?.wrappedValue = .active
                            }
                        }
                    }) {
                        if editMode?.wrappedValue.isEditing == true {
                            Text("Done")
                        } else {
                            Text("Sum")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Flow", systemImage: "plus")
                    }
                }
                
            }
            .sheet(isPresented: $showingAddView){
                AddFlowView(from: capacitor_id)
            }.background(Color.background)
            
            
        
    }
    
    private func deleteFlow(flow: Flow){
        
        withAnimation{
            let from_cap = flow.from
            let to_cap = flow.to
            
            managedObjContext.delete(flow)
            
            DataController().updateBalance(capacitor: from_cap!, context: managedObjContext)
            DataController().updateBalance(capacitor: to_cap!, context: managedObjContext)
            
            DataController().save(context: managedObjContext)
        }
    }
    
    private func sumFlows(flows: Set<Flow> ) -> Int {
        var sum = 0
        
        print("Hello from sumFlows!!")
       
        for flow in flows {
            if flow.from_id == capacitor_id {
                sum -= Int(flow.amount)
            } else{
                sum += Int(flow.amount)
            }
        }
        
        return sum
    }
//    private func deleteFlow(at offsets: IndexSet, in flow: SectionedFetchResults<String, Flow>.Element){
//
//
//        withAnimation{
//
//            offsets.map { flow[$0] }.forEach(managedObjContext.delete)
//
//
//            // CapacitorのBalanceを更新
//            for offset in offsets {
//                let from_cap = flow[offset].from
//                let to_cap = flow[offset].to
//
//                DataController().updateBalance(capacitor: from_cap!, context: managedObjContext)
//                DataController().updateBalance(capacitor: to_cap!, context: managedObjContext)
//            }
//
//
//
//
//            DataController().save(context: managedObjContext)
//        }
//    }
    private func currentBalance() -> Int {
        var totalBalance = self.init_balance
        
        
        for flowSection in flowSections {
            for flowEntry in flowSection {
                
                if Int(flowEntry.status) == Status.confirmed.rawValue {
                    if flowEntry.from_id == self.capacitor_id {
                        totalBalance -= Int(flowEntry.amount)
                    }else {
                        totalBalance += Int(flowEntry.amount)
                    }
                }
                
                
            }
        }
        return totalBalance
    }
    
    private func balance_of_the_day(flow: Flow, date: Date) -> Int {
        
        var balance = self.init_balance
        for flowSection in flowSections {
            for flowEntry in flowSection {
                
                //自分より前のFlowと自分
                if (flowEntry.date! < date) || ( flowEntry.date! == date && flowEntry.createdAt! < flow.createdAt!) || flowEntry.id == flow.id {
                    
                    
                    if flowEntry.status != Status.pending.rawValue {
                        if flowEntry.from_id == self.capacitor_id {
                            balance -= Int(flowEntry.amount)
                        }else {
                            balance += Int(flowEntry.amount)
                        }
                    }
                }
            }
        }
        return balance
    }
    

}


