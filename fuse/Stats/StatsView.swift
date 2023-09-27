//
//  StatsView.swift
//  Fuse
//
//  Created by araragi943 on 2023/09/27.
//

import SwiftUI
import CoreData

enum DirectionSelection {
    case income, outgo
}
struct StatsView: View {
    
    
    
    
    
    @Environment(\.managedObjectContext) var managedObjContext
    
    @State private var currentPeriod : PeriodSelection = .daily
    @State private var currentDirection : DirectionSelection = .outgo
    @State private var dateRange: (start: Date, end: Date) = getDailyRange()
    @State private var isButtonVisible : Bool = true
    @State private var showingAddChargeView = false
    @State private var lastUsedCapacitorId: UUID?
    
    
    var body: some View {
        
        ZStack {
            NavigationView {
                
                VStack {
                    
                    Picker("Period", selection: $currentPeriod) {
                        Text("Daily").tag(PeriodSelection.daily)
                        Text("Weekly").tag(PeriodSelection.weekly)
                        Text("Monthly").tag(PeriodSelection.monthly)
                        Text("Yearly").tag(PeriodSelection.yearly)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding([.horizontal,.top])
                    Picker("Direction", selection: $currentDirection) {
                        Text("Outgo").tag(DirectionSelection.outgo)
                        Text("Income").tag(DirectionSelection.income)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding([.bottom, .horizontal])
                    
                    
                    
                    
                    
                    
                    
                    CategoryStatsView(range: dateRange, direction: currentDirection, isButtonVisible: $isButtonVisible)
                    
                    
                    
                }.navigationTitle("Stats")
                
            }.onChange(of: currentPeriod) { newPeriod in
                
                if newPeriod == .daily {
                    self.dateRange = getDailyRange()
                } else if newPeriod == .weekly {
                    self.dateRange = getWeeklyRange()
                } else if newPeriod == .monthly {
                    self.dateRange = getMonthlyRange()
                } else {
                    self.dateRange = getYearlyRange()
                }
                
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
            
        }.sheet(isPresented: $showingAddChargeView){
            AddChargeView(openedCapId: $lastUsedCapacitorId)
        }.onAppear{
            self.lastUsedCapacitorId = DataController.shared.getLastUsedCapacitor(context: managedObjContext)
        }
        
        
    }
    
   
    

    
    
}


