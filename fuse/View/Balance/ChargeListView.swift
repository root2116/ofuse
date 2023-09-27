//
//  ChargeList.swift
//  Fuse
//
//  Created by araragi943 on 2023/09/27.
//

import SwiftUI

struct ChargeListView: View {
    @FetchRequest var charges: FetchedResults<Charge>
    
    var dateRange: (start: Date, end: Date)
    @Environment(\.managedObjectContext) var managedObjContext
    @Binding var isButtonVisible : Bool
    
    @Binding var currentTab: TabSelection
    
    @State private var income: Int32 = 0
    @State private var outgo: Int32 = 0
    init(range: (start: Date, end: Date), currentTab: Binding<TabSelection>,  isButtonVisible: Binding<Bool>){
        self.dateRange = range
        
        
        self._charges = FetchRequest(entity: Charge.entity(),
                                     sortDescriptors: [NSSortDescriptor(keyPath: \Charge.date, ascending: false), NSSortDescriptor(keyPath: \Charge.createdAt, ascending: false)],
                                     predicate: NSPredicate(format: "(from_id == %@ || to_id == %@) && (date >= %@ && date < %@)", srcId! as CVarArg, gndId! as CVarArg, range.start as NSDate, range.end as NSDate))
        
        self._currentTab = currentTab
        self._isButtonVisible = isButtonVisible
        
        
        
    }
    
    var body: some View {
        VStack {
            
            
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    
                    Text("Outgo")
                        .font(.title)
                    Text("¥ \(calculateOutgo(charges:charges))")
                        .font(.title)
                        .foregroundColor(.red)
                    
                }
                
                Spacer()
                Divider()
                Spacer()
                VStack(alignment: .center) {
                    
                    Text("Income")
                        .font(.title)
                    
                    Text("¥ \(calculateIncome(charges:charges))").font(.title)
                        .foregroundColor(.green)
                    
                }
                
                Spacer()
            }
            .frame(height: 75)
            
            
            
            Divider()
            
            // Charges List
            List {
                ForEach(charges, id: \.self) { chargeEntry in
                    
                    
                    if chargeEntry.status == Status.pending.rawValue {
                        if chargeEntry.included {
                            HomeChargeView(charge: chargeEntry, isButtonVisible: $isButtonVisible)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        DataController.shared.togglePending(charge: chargeEntry, context: managedObjContext)
                                    } label: {
                                        Image(systemName: "questionmark")
                                    }.tint(.gray)
                                }
                        } else {
                            HomeChargeView(charge: chargeEntry, isButtonVisible: $isButtonVisible)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        DataController.shared.togglePending(charge: chargeEntry, context: managedObjContext)
                                    } label: {
                                        Image(systemName: "link")
                                    }.tint(.cyan)
                                }
                        }
                    } else {
                        if chargeEntry.status == Status.confirmed.rawValue {
                            HomeChargeView(charge: chargeEntry, isButtonVisible: $isButtonVisible)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        DataController.shared.toggleUpcoming(charge: chargeEntry, context: managedObjContext)
                                    } label: {
                                        Image(systemName: "hourglass")
                                    }.tint(.orange)
                                }
                        } else if chargeEntry.status == Status.upcoming.rawValue {
                            HomeChargeView(charge: chargeEntry, isButtonVisible: $isButtonVisible)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        DataController.shared.toggleUpcoming(charge: chargeEntry, context: managedObjContext)
                                    } label: {
                                        Image(systemName: "checkmark")
                                    }.tint(.green)
                                }
                        }
                    }
                    
                }
            }.listStyle(.plain)
            
            
            
        }
    }
    
    
    func calculateIncome(charges: FetchedResults<Charge>) -> Int32 {
        
        var sum: Int32 = 0
        for charge in charges {
            if(charge.from_id == srcId! && (charge.status == Status.confirmed.rawValue || (charge.status == Status.pending.rawValue && charge.included))){
                sum += charge.amount
            }
        }
        
        return sum
    }
    
    func calculateOutgo(charges: FetchedResults<Charge>) -> Int32 {
        
        var sum: Int32 = 0
        for charge in charges {
            if(charge.to_id == gndId! && (charge.status == Status.confirmed.rawValue || (charge.status == Status.pending.rawValue && charge.included))){
                sum += charge.amount
            }
        }
        return sum
    }

    
    
    
}

