import SwiftUI
import CoreData


struct HomeView: View {
    enum TabSelection {
        case daily, weekly, monthly
    }
    
    @State private var currentTab: TabSelection = .daily
    @Environment(\.managedObjectContext) var managedObjContext
    
    @FetchRequest var dailyCharges: FetchedResults<Charge>
    @FetchRequest var weeklyCharges: FetchedResults<Charge>
    @FetchRequest var monthlyCharges: FetchedResults<Charge>
    
    @State private var isButtonVisible = true
    @State private var showingAddChargeView = false
    
    @State private var lastUsedCapacitorId: UUID?
    
    init(){
        let dailyStartDate = Calendar.current.startOfDay(for: Date())
        let dailyEndDate = Calendar.current.date(byAdding: .day, value: 1, to: dailyStartDate)!
        self._dailyCharges = FetchRequest(
                                sortDescriptors: [
                                    SortDescriptor(\.date, order: .reverse),
                                    SortDescriptor(\.createdAt, order: .reverse)
           
                                ],
                                predicate: NSPredicate(format: "(from_id == %@ || to_id == %@) && (date >= %@ && date < %@)", srcId! as CVarArg, gndId! as CVarArg, dailyStartDate as NSDate, dailyEndDate as NSDate),
                                animation: nil)
        
        let weeklyStartDate = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let weeklyEndDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: weeklyStartDate)!
        
        self._weeklyCharges = FetchRequest(
                                sortDescriptors: [
                                    SortDescriptor(\.date, order: .reverse),
                                    SortDescriptor(\.createdAt, order: .reverse)

                                ],
                                predicate: NSPredicate(format: "(from_id == %@ || to_id == %@) && (date >= %@ && date < %@)", srcId! as CVarArg, gndId! as CVarArg, weeklyStartDate as NSDate, weeklyEndDate as NSDate),
                                animation: nil)
        
        let monthlyStartDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
        let monthlyEndDate = Calendar.current.date(byAdding: .month, value: 1, to: monthlyStartDate)!
        self._monthlyCharges = FetchRequest(
                                sortDescriptors: [
                                    SortDescriptor(\.date, order: .reverse),
                                    SortDescriptor(\.createdAt, order: .reverse)

                                ],
                                predicate: NSPredicate(format: "(from_id == %@ || to_id == %@) && (date >= %@ && date < %@)", srcId! as CVarArg, gndId! as CVarArg, monthlyStartDate as NSDate, monthlyEndDate as NSDate),
                                animation: nil)
        
        
    }

    
    
    

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    // Tab Selection
                    Picker("Duration", selection: $currentTab) {
                        Text("Daily").tag(TabSelection.daily)
                        Text("Weekly").tag(TabSelection.weekly)
                        Text("Monthly").tag(TabSelection.monthly)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    // Income and Expenditure
                    HStack {
                        Spacer()
                        VStack(alignment: .center) {
                            
                            Text("Outgo")
                                .font(.title)
                            if currentTab == .daily {
                                Text("¥ \(calculateOutgo(charges: dailyCharges))")
                                    .font(.title)
                                    .foregroundColor(.red)
                            } else if currentTab == .weekly {
                                Text("¥ \(calculateOutgo(charges: weeklyCharges))")
                                    .font(.title)
                                    .foregroundColor(.red)
                            } else {
                                Text("¥ \(calculateOutgo(charges: monthlyCharges))")
                                    .font(.title)
                                    .foregroundColor(.red)
                            }
                            
                        }
                        
                        Spacer()
                        Divider()
                        Spacer()
                        VStack(alignment: .center) {
                            
                            Text("Income")
                                .font(.title)
                            if currentTab == .daily {
                                Text("¥ \(calculateIncome(charges: dailyCharges))").font(.title)
                                    .foregroundColor(.green)
                            } else if currentTab == .weekly {
                                Text("¥ \(calculateIncome(charges: weeklyCharges))").font(.title)
                                    .foregroundColor(.green)
                            } else {
                                Text("¥ \(calculateIncome(charges: monthlyCharges))").font(.title)
                                    .foregroundColor(.green)
                            }
                            
                        }
                        
                        Spacer()
                    }
                    .frame(height: 75)

                    
                    
                    Divider()
                    
                    // Charges List
                    List {
                        ForEach(currentTab == .daily ? dailyCharges : (currentTab == .weekly ? weeklyCharges : monthlyCharges), id: \.self) { chargeEntry in
                                
                                
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
                }.navigationTitle("Balances")
            }.sheet(isPresented: $showingAddChargeView){
                AddChargeView(openedCapId: $lastUsedCapacitorId)
            }
            
            if isButtonVisible {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showingAddChargeView.toggle()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color.green)
                                .background(Color.white)
                                .clipShape(Circle())
                                .padding()
                        }
                    }
                }
            }
        }.onAppear{
            self.lastUsedCapacitorId = DataController.shared.getLastUsedCapacitor(context: managedObjContext)
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
        return sum // Placeholder value
    }
}

