//
//  ContentView.swift
//  fuse
//
//  Created by araragi943 on 2022/06/09.
//

import SwiftUI
import CoreData
import UserNotifications


enum Status: Int {
    case confirmed = 0
    case upcoming = 1
    case pending = 2
}

enum CapType: Int16 {
    case cash = 0
    case bank = 1
    case card = 2
}
struct CapId: EnvironmentKey {
    static var defaultValue: UUID = UUID()
}

extension EnvironmentValues {
    var gndId: UUID {
        get { self[CapId.self] }
        set { self[CapId.self] = newValue}
    }
    var srcId: UUID {
        get { self[CapId.self] }
        set { self[CapId.self] = newValue}
    }
}

var srcId = UUID(uuidString: "CE130F1C-3B2F-42CA-8339-1549531E0102")
var gndId = UUID(uuidString: "466762d8-0419-e4b5-6e57-c972e05bd2a6")
var newId = UUID(uuidString: "2a2c5eec-bef1-11ed-afa1-0242ac120002")
var uncatId = UUID(uuidString: "bafdfb88-bef1-11ed-afa1-0242ac120002")


struct ContentView: View {
    
    @State var timer :Timer?
    @Environment(\.managedObjectContext) var managedObjContext
   

    init() {
      // 文字色
      UITabBar.appearance().unselectedItemTintColor = .gray
//      // 背景色
       
        UITabBar.appearance().backgroundColor = .systemBackground
        
        
        
        
    }
    
    var body: some View {
        
            TabView{
                BalancesView()
                    .tabItem {
                        Image(systemName: "arrow.up.arrow.down")
                        Text("Balances")
                    }
                CapacitorsView() //1枚目の子ビュー
                    .tabItem {
                        Image(systemName: "macpro.gen2.fill")
                        Text("Capacitors")
                    }
//                    .environment(\.srcId, srcId!).environment(\.gndId, gndId!)
                CurrentsView() //2枚目の子ビュー
                    .tabItem {
                        Image(systemName: "arrow.triangle.pull")
                        Text("Currents")
                    }
            }.onAppear{

                //　Core Dataの初期化をするならこれをコメントアウトする
//                initCoreData(context: managedObjContext)
                
                
                if DataController.shared.isFirstLaunch() {
                    print("initialization!")
                    // Wait for initial sync to complete
                    _ = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
                        
                        timer.invalidate()

                        // Execute your desired action
                        print("Initial sync completed!")
                        DataController.shared.init_cap(context: managedObjContext, capId: srcId!, capName: "Source")
                        DataController.shared.init_cap(context: managedObjContext, capId: gndId!, capName: "Ground")
                        DataController.shared.init_tag(context: managedObjContext)
                        DataController.shared.init_cat(context: managedObjContext, catId: uncatId!, catName: "Uncategorized")
                        
                    }
                }
                
                
                
               
            }
        }
    
    
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


extension Charge {
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

//extension Capacitor {
//    @objc
//    var typeText: String {
//        if self.type == CapType.bank.rawValue {
//            return "Account"
//        } else if self.type == CapType.cash.rawValue {
//            return "Cash"
//        } else {
//            return "Credit Card"
//        }
//    }
//}

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



