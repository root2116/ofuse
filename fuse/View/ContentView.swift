//
//  ContentView.swift
//  fuse
//
//  Created by araragi943 on 2022/06/09.
//

import SwiftUI
import CoreData


enum Status: Int {
    case confirmed = 0
    case pending = 1
    case uncertain = 2
    case tentative = 3
}

enum CapType: Int16 {
    case cash = 0
    case bank = 1
    case card = 2
}
struct OutsideId: EnvironmentKey {
    static var defaultValue: UUID = UUID()
}

extension EnvironmentValues {
    var outsideId: UUID {
        get { self[OutsideId.self] }
        set { self[OutsideId.self] = newValue}
    }
}



struct ContentView: View {
    
    @State var timer :Timer?
    @Environment(\.managedObjectContext) var managedObjContext
    
    var body: some View {
        
            TabView{
                CapacitorsView() //1枚目の子ビュー
                    .tabItem {
                        Image(systemName: "macpro.gen2.fill")
                        Text("Capacitors")
                    }
                ConductorsView() //2枚目の子ビュー
                    .tabItem {
                        Image(systemName: "arrow.triangle.pull")
                        Text("Conductors")
                    }
            }.onAppear{
//                registSampleData(context: managedObjContext)
                registerOutside(context: managedObjContext)
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    // Conductorから追加するべきFlowがあればCapacitorに追加する。
                    DataController().applyConductors(context: managedObjContext)
                    
                    
                }
            }
        }
    
    
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


extension Flow {
    @objc
    var dateText: String {
        guard let date = self.date else {
            return "Unknown"
        }
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM"
        return format.string(from: date)
    }
}

extension Capacitor {
    @objc
    var typeText: String {
        if self.type == CapType.bank.rawValue {
            return "Account"
        } else if self.type == CapType.cash.rawValue {
            return "Cash"
        } else {
            return "Credit Card"
        }
    }
}

//extension Color {
//        static var backgroundColor: Color {
//            Color("backgroundColor")
//        }
//    }

extension Color {
    static let background = Color("background")
}

//extension Conductor {
//    @objc
//    var next: Date {
////        let flows = flowArray(self.flows)
////        let today = Date()
////        var old: Date?
////        for flow in flows {
////            old = flow.date
////            if flow.date! > today {
////                return old!
////            }
////        }
//
//        return Date()
//
//    }
//}

extension String {
    func size(with font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font : font]
        return (self as NSString).size(withAttributes: attributes)
    }
}



