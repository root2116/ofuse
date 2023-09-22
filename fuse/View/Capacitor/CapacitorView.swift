//
//  CapacitorView.swift
//  fuse
//
//  Created by araragi943 on 2022/08/13.
//

import SwiftUI

class Node {
    var balance: Int
    var amount: Int
    var pred: Node?
    var next: Node?

    init(amount: Int, pred: Node? = nil, next: Node? = nil) {
        self.amount = amount
        self.pred = pred
        self.next = next
        
        
        if let pred = self.pred {
            self.balance = pred.amount + amount
        } else {
            self.balance = amount
        }
        
    }
}



struct LinkedList {
 
    var head: Node?
    var tail: Node?

    var isEmpty: Bool { head == nil }

    init() {}
    
    mutating func append(_ amount: Int) -> Node {
        let node = Node(amount: amount, pred: tail)
        
        node.pred = tail
        tail = node
        
        return node
    }
    
    func insert(_ amount: Int, _ after: Node) -> Node {
        let node = Node(amount: amount, pred: after, next: after.next)
        
        after.next = node
        if let after_next = after.next {
            after_next.pred = node
            var p: Node? = after_next
            while p != nil {
                p!.balance = p!.pred!.balance + p!.amount
                p = p!.next
            }
        }
        
        
        return node
        
    }
    
}



struct CapacitorView: View {
    
    
    @Environment(\.managedObjectContext) var managedObjContext
    

    @SectionedFetchRequest<String, Charge> var chargeSections : SectionedFetchResults<String, Charge>
    
    var capacitorId : UUID
    var capacitorName : String
    
    private var initBalance = 0
    
    
    @State private var chargeList  = LinkedList()
    @State private var chargeTable : [UUID: Node] = [:]
  

    init(capacitorId: UUID, capacitorName: String, isButtonVisible: Binding<Bool>){
        self.capacitorId = capacitorId
        self.capacitorName = capacitorName
        
        self._chargeSections = SectionedFetchRequest<String,Charge>(
                                sectionIdentifier: \.dateText,
                                sortDescriptors: [
                                    SortDescriptor(\.date, order: .reverse),
                                    SortDescriptor(\.createdAt, order: .reverse)
           
                                ],
                                predicate: NSPredicate(format: "from_id == %@ || to_id == %@", capacitorId as CVarArg, capacitorId as CVarArg ),
                                animation: nil)
        
        
        self._isButtonVisible = isButtonVisible
    }


    @State private var showingAddView = false
    @Binding var isButtonVisible: Bool
//    @State private var selectionValues: Set<Charge> = []
    
    
    
    @State private var sum: Int = 0
    

    @Environment(\.editMode) var editMode
    
    
    
    var body: some View {
        let initBalance = DataController.shared.fetchCapInitBalance(capId: capacitorId, context: managedObjContext)
        
        
        
        ZStack{
            VStack(alignment: .leading) {
                Text("Balance: \(DataController.shared.fetchCapBalance(capId: capacitorId, context: managedObjContext)) yen as of \(formatDate(date:Date(),formatStr:"M/d"))")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                //                if editMode?.wrappedValue.isEditing == true {
                //                    Text("Sum: \(sumCharges(charges:selectionValues)) yen")
                //                        .foregroundColor(.gray)
                //                        .padding(.horizontal)
                //                }
                
                
                List {
                    
                    
                    Button(action: {
                        DataController.shared.generateNextCharge(capId: capacitorId, context: managedObjContext)
                    }){
                        HStack{
                            Spacer()
                            Image(systemName: "arrow.up.circle").foregroundColor(Color.blue)
                            Spacer()
                        }
                        
                    }
                    ForEach(chargeSections){ section in
                        Section(section.id) {
                            ForEach(section, id: \.self) { chargeEntry in
                                
                                
                                //                                ChargeView(charge: chargeEntry, openedCapId: capacitorId, balance: (chargeEntry.from_id == capacitorId) ? Int(chargeEntry.from_balance) + initBalance : Int(chargeEntry.to_balance) + initBalance)
                                
                                
                                
                                if chargeEntry.status == Status.pending.rawValue {
                                    if chargeEntry.included {
                                        ChargeView(charge: chargeEntry, isButtonVisible: $isButtonVisible, openedCapId: capacitorId, balance: (capacitorId == chargeEntry.from_id) ? Int(chargeEntry.from_balance) + initBalance: Int(chargeEntry.to_balance) + initBalance)
                                            .swipeActions(edge: .leading) {
                                                Button {
                                                    DataController.shared.togglePending(charge: chargeEntry, context: managedObjContext)
                                                } label: {
                                                    Image(systemName: "questionmark")
                                                }.tint(.gray)
                                            }
                                    } else {
                                        ChargeView(charge: chargeEntry,  isButtonVisible: $isButtonVisible, openedCapId: capacitorId, balance: (capacitorId == chargeEntry.from_id) ? Int(chargeEntry.from_balance) + initBalance: Int(chargeEntry.to_balance) + initBalance)
                                            .swipeActions(edge: .leading) {
                                                Button {
                                                    DataController.shared.togglePending(charge: chargeEntry, context: managedObjContext)
                                                } label: {
                                                    Image(systemName: "link")
                                                }.tint(.cyan)
                                            }
                                    }
                                    
                                } else if chargeEntry.status == Status.upcoming.rawValue {
                                    ChargeView(charge: chargeEntry, isButtonVisible: $isButtonVisible, openedCapId: capacitorId, balance: (capacitorId == chargeEntry.from_id) ? Int(chargeEntry.from_balance) + initBalance: Int(chargeEntry.to_balance) + initBalance)
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                DataController.shared.toggleUpcoming(charge: chargeEntry, context: managedObjContext)
                                            } label: {
                                                Image(systemName: "checkmark")
                                            }.tint(.green)
                                        }
                                } else {
                                    ChargeView(charge: chargeEntry,  isButtonVisible: $isButtonVisible, openedCapId: capacitorId, balance: (capacitorId == chargeEntry.from_id) ? Int(chargeEntry.from_balance) + initBalance: Int(chargeEntry.to_balance) + initBalance)
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                DataController.shared.toggleUpcoming(charge: chargeEntry, context: managedObjContext)
                                            } label: {
                                                Image(systemName: "hourglass")
                                            }.tint(.orange)
                                        }
                                }
                                
                                
                            }
                            .onDelete {
                                self.deleteCharge(at: $0, in: section)
                            }.onMove { indices, newOffset in
                                self.moveCharge(from: indices, to: newOffset, in: section)
                            }                        }
                    }
                    //                    .listRowBackground(Color.background)
                }
                .listStyle(.plain)
               
//                .toolbar {
//                    EditButton()
//                }
                //                .background(Color.background)
                
            }
            .navigationTitle(self.capacitorName)
            .toolbar {
                //                ToolbarItem(placement: .navigationBarTrailing){
                //
                //
                //                    Button(action: {
                //                        withAnimation() {
                //                            if editMode?.wrappedValue.isEditing == true {
                //                                editMode?.wrappedValue = .inactive
                //                            } else {
                //                                editMode?.wrappedValue = .active
                //                            }
                //                        }
                //                    }) {
                //                        if editMode?.wrappedValue.isEditing == true {
                //                            Text("Done")
                //                        } else {
                //                            Text("Sum")
                //                        }
                //                    }
                //                }
               
                
            }
            .sheet(isPresented: $showingAddView){
                AddChargeView(openedCapId: capacitorId)
            }.onAppear {
                DataController.shared.updateChargeBalances(capId: capacitorId, context: managedObjContext)
            }
            
//            if isButtonVisible {
//                VStack {
//                                Spacer()
//                                HStack {
//                                    Spacer()
//                                    
//                                    Button(action: {
//                                        self.showingAddView.toggle()
//                                    }) {
//                                        Image(systemName: "plus.circle.fill")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 60, height: 60)
//                                            .foregroundColor(Color.green)
//                                            .background(Color.white)
//                                            .clipShape(Circle())
//                                            .padding()
//                                    }
//                                
//                                    
//                                }
//                }
//            }
            
            
        }

        
    }
    
//    private func registerCharges() {
//        for section in chargeSections {
//            for charge in section {
//                if charge.from_id == capacitorId {
//                    let node = chargeList.append(-Int(charge.amount))
//                    chargeTable[charge.id!] = node
//                } else {
//                    let node = chargeList.append(Int(charge.amount))
//                    chargeTable[charge.id!] = node
//                }
//
//            }
//        }
//    }
    private func deleteCharge(at offsets: IndexSet, in section: SectionedFetchResults<String, Charge>.Element){
        
        for offset in offsets {
            let charge = section[offset]

            guard let from_cap = charge.from else { print("from is nil"); return }
            guard let to_cap = charge.to else { print("to is nil"); return }


            if charge.status == Status.confirmed.rawValue {
                from_cap.balance += charge.amount
                to_cap.balance -= charge.amount
            }


            managedObjContext.delete(charge)
            DataController.shared.save(context: managedObjContext)
            

        }

//        DataController.shared.updateVariableCharge(context: managedObjContext)
//            
//        DataController.shared.save(context: managedObjContext)
       
        
    }
    private func moveCharge(from source: IndexSet, to destination: Int, in section: SectionedFetchResults<String, Charge>.Element) {
        // sourceから移動するChargeを取得
        
        managedObjContext.perform {
            let movingCharge = section[source.first!]
            
            let previousCharge = (destination - 1 >= 0) ? section[destination - 1] : nil
            let nextCharge = (destination < section.count) ? section[destination] : nil
            
            if let prevDate = previousCharge?.date, let nextDate = nextCharge?.date {
                let interval = nextDate.timeIntervalSince(prevDate) / 2
                movingCharge.date = prevDate.addingTimeInterval(interval)
            } else if let prevDate = previousCharge?.date {
                movingCharge.date = prevDate.addingTimeInterval(-1) // 1日後
            } else if let nextDate = nextCharge?.date {
                movingCharge.date = nextDate.addingTimeInterval(1) // 1日前
            }

            // データベースの変更を保存
            DataController.shared.save(context: managedObjContext)
        }
        
    }
    
    private func sumCharges(charges: Set<Charge> ) -> Int {
        var sum = 0
        
        print("Hello from sumCharges!!")
       
        for charge in charges {
            if charge.from_id == capacitorId {
                sum -= Int(charge.amount)
            } else{
                sum += Int(charge.amount)
            }
        }
        
        return sum
    }
    
    
//    private func deleteCharge(at offsets: IndexSet, in Charge: SectionedFetchResults<String, Charge>.Element){
//
//
//        withAnimation{
//
//            offsets.map { Charge[$0] }.forEach(managedObjContext.delete)
//
//
//            // CapacitorのBalanceを更新
//            for offset in offsets {
//                let from_cap = Charge[offset].from
//                let to_cap = Charge[offset].to
//
//                DataController.shared.updateBalance(capacitor: from_cap!, context: managedObjContext)
//                DataController.shared.updateBalance(capacitor: to_cap!, context: managedObjContext)
//            }
//
//
//
//
//            DataController.shared.save(context: managedObjContext)
//        }
//    }
    private func balance_of_the_day(charge: Charge) -> Int {
        if let node = chargeTable[charge.id!] {
            return node.balance
        } else {
            if let pred = DataController.shared.predCharge(targetCharge: charge, capId: capacitorId, context: managedObjContext) {
                
                if let pred_node = chargeTable[pred.id!] {
                    var node : Node
                    if charge.from_id == capacitorId {
                        node = chargeList.insert(-Int(charge.amount), pred_node)
                    } else {
                        node = chargeList.insert(Int(charge.amount), pred_node)
                    }
                    
                    chargeTable[charge.id!] = node
                    
                    return node.balance
                } else {
                    var node: Node
                    if charge.from_id == capacitorId {
                        node = chargeList.append(-Int(charge.amount))
                    } else {
                        node = chargeList.append(Int(charge.amount))
                    }
                   
                    return node.balance
                    
                }
                
                
            } else {
                
                if charge.from_id == capacitorId {
                    return -Int(charge.amount)
                } else {
                    return Int(charge.amount)
                }
                
                
            }
                
            
            
        }
    }
    
//    private func balance_of_the_day(charge: Charge, date: Date) -> Int {
//
//        var balance = DataController.shared.fetchCapBalance(capId: capacitorId, context: managedObjContext)
//
//
//        for chargeSection in chargeSections {
//            for chargeEntry in chargeSection {
//
//                //自分より前のChargeと自分
//                if (chargeEntry.date! < date) || ( chargeEntry.date! == date && chargeEntry.createdAt! < charge.createdAt!) || chargeEntry.id == charge.id {
//
//
//                    if chargeEntry.status != Status.pending.rawValue {
//                        if chargeEntry.from_id == self.capacitorId {
//                            balance += Int(chargeEntry.amount)
//                        }else {
//                            balance -= Int(chargeEntry.amount)
//                        }
//                    }
//                }
//            }
//        }
//        return balance
//    }
//

}

//struct CurrentsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrentsView()
//    }
//}
//
