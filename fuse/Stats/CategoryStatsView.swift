//
//  CategoriesView.swift
//  Fuse
//
//  Created by araragi943 on 2023/09/27.
//

import SwiftUI

struct CategoryStatsView: View {
    
    
    @FetchRequest private var charges: FetchedResults<Charge>
    
    private var groupedCharges: [String: [Charge]] {
        Dictionary(grouping: charges, by: {$0.category!.name!})
    }
    
    var direction: DirectionSelection
    var range: (start: Date, end: Date)
    
    @Binding var isButtonVisible : Bool
    
    init(range: (start: Date, end: Date), direction: DirectionSelection, isButtonVisible: Binding<Bool>){
        
        self._isButtonVisible = isButtonVisible
        self.direction = direction
        self.range = range
        if direction == .income {
            self._charges = FetchRequest(entity: Charge.entity(),
                                         sortDescriptors: [NSSortDescriptor(keyPath: \Charge.date, ascending: false)],
                                         predicate: NSPredicate(format: "(from_id == %@) && (date >= %@ && date < %@)", srcId! as CVarArg, range.start as NSDate, range.end as NSDate))
        } else {
            self._charges = FetchRequest(entity: Charge.entity(),
                                         sortDescriptors: [NSSortDescriptor(keyPath: \Charge.date, ascending: false)],
                                         predicate: NSPredicate(format: "(to_id == %@) && (date >= %@ && date < %@)", gndId! as CVarArg, range.start as NSDate, range.end as NSDate))
        }
    }
    
    var body: some View {
        
        VStack {
            
            PieChartView(segments: groupedCharges.map {
                Segment(value: Double(sumOfAmount(for: $0.key)), color: colorFromString($0.key))
            }).frame(width: 200, height: 200)
            
            List {
                ForEach(groupedCharges.keys.sorted(), id: \.self) { category in
                    NavigationLink(destination: CategoryChargeListView(charges: groupedCharges[category]!, isButtonVisible: $isButtonVisible)) {
                        HStack {
                            Text("\(percent(for:category)) %")
                                .padding(.all, 5)
                                .font(.callout)
                                .background(RoundedRectangle(cornerRadius: 5)
                                    .fill(colorFromString(category)))
                                .foregroundColor(.white)
                            Text(category)
                            Spacer()
                            Text("¥ \(sumOfAmount(for:category))")
                        }
                    }
                    
                    
                }
            }.listStyle(.plain)
            
        }
    }
    
    private func sumOfAmount(for category: String) -> Int32 {
        print(groupedCharges.keys)
        var sum: Int32 = 0
        let group = groupedCharges[category]!
        
        for charge in group {
            sum += charge.amount
        }
        return sum
    }
    
    private func percent(for category: String) -> Int32 {
        var total : Int32 = 0
        for charge in charges {
            total += charge.amount
        }
        
        var target : Int32 = 0
        for charge in groupedCharges[category]! {
            target += charge.amount
        }
        
        
        if total == 0 { return 0 } // Avoid division by zero
        let percentage = Double(target) / Double(total) * 100
        return Int32(percentage)
        
        
    }
    
    
    func colorFromString(_ str: String) -> Color {
        let values = str.unicodeScalars.map { Double($0.value) }
        let red = values.reduce(0, +).truncatingRemainder(dividingBy: 256) / 255.0
        let green = values.reversed().reduce(0, +).truncatingRemainder(dividingBy: 256) / 255.0
        let blue = (values.first ?? 0 + (values.last ?? 0) ).truncatingRemainder(dividingBy: 256) / 255.0
        return Color(red: red, green: green, blue: blue, opacity: 1.0)
    }
}

