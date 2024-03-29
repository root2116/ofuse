import SwiftUI
import CoreData



var dailyDateRange = getDailyRange()
var weeklyDateRange = getWeeklyRange()
var monthlyDateRange = getMonthlyRange()
enum PeriodSelection {
    case daily, weekly, monthly, yearly
}
struct BalancesView: View {
    
    
    @State private var currentTab: PeriodSelection = .daily
    @Environment(\.managedObjectContext) var managedObjContext
    
    @State private var dateRange: (start: Date, end: Date) = getDailyRange()
    @State private var income: Int32 = 0
    @State private var outgo: Int32 = 0
    
    
    @State private var isButtonVisible = true
    @State private var showingAddChargeView = false
    
    @State private var lastUsedCapacitorId: UUID?
    @State private var currentDate: Date = Calendar.current.startOfDay(for: Date())
    
    
    

    
    
    

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    // Tab Selection
                    Picker("Duration", selection: $currentTab) {
                        Text("Daily").tag(PeriodSelection.daily)
                        Text("Weekly").tag(PeriodSelection.weekly)
                        Text("Monthly").tag(PeriodSelection.monthly)
                        Text("Yearly").tag(PeriodSelection.yearly)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    // Income and Expenditure
                    
                    ChargeListView(range: dateRange, currentTab: $currentTab, isButtonVisible: $isButtonVisible)
                    
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
            
            setupDateCheck()
        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            // アプリがフォアグラウンドに来るたびに日付をチェック
            setupDateCheck()
        }.onChange(of: currentTab) { newTab in
            
            if newTab == .daily {
                self.dateRange = getDailyRange()
            } else if newTab == .weekly {
                self.dateRange = getWeeklyRange()
            } else if newTab == .monthly {
                self.dateRange = getMonthlyRange()
            } else {
                self.dateRange = getYearlyRange()
            }
            
        }.onChange(of: currentDate) { _ in
            if currentTab == .daily {
                self.dateRange = getDailyRange()
            } else if currentTab == .weekly {
                self.dateRange = getWeeklyRange()
            } else if currentTab == .monthly {
                self.dateRange = getMonthlyRange()
            } else {
                self.dateRange = getYearlyRange()
            }
        }
        
        
    }
    
    
   
    
    func setupDateCheck() {
            print("setupDateCheck")
            let newDate = Calendar.current.startOfDay(for: Date())
            if newDate != currentDate {
                self.currentDate = newDate
                
                
       
            }
        }
    
 
    
    
}

