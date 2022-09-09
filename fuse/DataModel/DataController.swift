//
//  DataController.swift
//  fuse
//
//  Created by araragi943 on 2022/06/09.
//

import Foundation
import CoreData
import SwiftUI



let outside_id = UUID(uuidString: "CE130F1C-3B2F-42CA-8339-1549531E0102")

func registerOutside(context: NSManagedObjectContext){
    
    let fetchRequestConductor = NSFetchRequest<NSFetchRequestResult>()
    fetchRequestConductor.entity = Conductor.entity()
    let conductors = try? context.fetch(fetchRequestConductor) as? [Conductor]
    
    for conductor in conductors! {
        if conductor.flows!.count > 0 {
            print("\(conductor.name!) has flows")
        }else {
            print("\(conductor.name!) doesn't have flows")
        }
        
    }
    
        
        
//    let outside_id = "CE130F1C-3B2F-42CA-8339-1549531E0102"
    
    
//    /// Flowテーブル全消去
//    let fetchRequestFlow = NSFetchRequest<NSFetchRequestResult>()
//    fetchRequestFlow.entity = Flow.entity()
//    let flows = try? context.fetch(fetchRequestFlow) as? [Flow]
//    for flow in flows! {
//        context.delete(flow)
//    }
//
//    /// Capacitorテーブル全消去
//    let fetchRequestCapacitor = NSFetchRequest<NSFetchRequestResult>()
//    fetchRequestCapacitor.entity = Capacitor.entity()
//    let capacitors = try? context.fetch(fetchRequestCapacitor) as? [Capacitor]
//    for capacitor in capacitors! {
//        context.delete(capacitor)
//    }
//
//
//    /// Conductorテーブル全消去
//    let fetchRequestConductor = NSFetchRequest<NSFetchRequestResult>()
//    fetchRequestConductor.entity = Conductor.entity()
//    let conductors = try? context.fetch(fetchRequestConductor) as? [Conductor]
//    for conductor in conductors! {
//        context.delete(conductor)
//    }
//
//    /// Categoryテーブル全消去
//    let fetchRequestCategory = NSFetchRequest<NSFetchRequestResult>()
//    fetchRequestCategory.entity = Category.entity()
//    let categories = try? context.fetch(fetchRequestCategory) as? [Category]
//    for category in categories! {
//        context.delete(category)
//    }
    
    let outside = [outside_id!.uuidString,"Outside", "0","0","0"]

    let fetchRequestCapacitor = NSFetchRequest<NSFetchRequestResult>()
    fetchRequestCapacitor.entity = Capacitor.entity()
    let capacitors = try? context.fetch(fetchRequestCapacitor) as? [Capacitor]
    if capacitors!.count == 0 {
        let newCapacitor = Capacitor(context: context)
        newCapacitor.id = UUID(uuidString: outside[0])
        newCapacitor.createdAt = Date()
        newCapacitor.name = outside[1]
        newCapacitor.init_balance = Int32(outside[2])!
        newCapacitor.balance = Int32(outside[2])!
        newCapacitor.settlement = Int16(outside[3])!
        newCapacitor.payment = Int16(outside[4])!
    }
    
    let fetchRequestCategory = NSFetchRequest<NSFetchRequestResult>()
    fetchRequestCategory.entity = Category.entity()
    
    
    var hasUncategorized = false
    let categories = try? context.fetch(fetchRequestCategory) as? [Category]
    if categories!.count > 0 {
        for category in categories! {
            if category.name == "Uncategorized" {
                hasUncategorized = true
            }
        }
    }
    
    if hasUncategorized == false {
        let newCategory = Category(context: context)
        newCategory.id = UUID()
        newCategory.createdAt = Date()
        newCategory.name = "Uncategorized"
    }

    try? context.save()
    
}

func registSampleData(context: NSManagedObjectContext) {
    
    print("Register!!")
    
    let outside_id = "CE130F1C-3B2F-42CA-8339-1549531E0102"
    let bank_id = UUID().uuidString
    let credit_id = UUID().uuidString
    
    
    let subscription_id = UUID().uuidString
    let uncategorized_id = UUID().uuidString
    
    let categoryList = [[uncategorized_id,"Uncategorized"],[subscription_id,"Subscription"]]
    
    print("Outside: \(outside_id)")
    print("Bank: \(bank_id)")
    print("Credit: \(credit_id)")
    /// Flowテーブル初期値
    let flowList = [
        [bank_id,outside_id,"お菓子","200","0","2022-08-14"],
        [bank_id,outside_id,"雑誌","2200","0","2022-08-14"],
        [credit_id,outside_id,"本","3000","0", "2022-09-10"],
        [credit_id,outside_id,"チケット","10000","0","2022-09-12"],
        [outside_id,bank_id,"給料","20000","0","2022-10-11"]
    ]
        
    /// Capacitorテーブル初期値
    let capacitorList = [
        [outside_id,"Outside", "0","0","0"],
        [bank_id,"Bank", "10000","0","0"],
        [credit_id,"Credit Card", "10000","10","2"]
    ]
    
    
    /// 0は*, -1は月末を表す
    let conductorList = [
        // from_id, to_id, name, amount,every,span, day, month, weekday, category
        [credit_id,outside_id,"日向坂ファンクラブ","440","1","month","25","0","0","Subscription"]
    
    ]
    
    /// Flowテーブル全消去
    let fetchRequestFlow = NSFetchRequest<NSFetchRequestResult>()
    fetchRequestFlow.entity = Flow.entity()
    let flows = try? context.fetch(fetchRequestFlow) as? [Flow]
    for flow in flows! {
        context.delete(flow)
    }
    
    /// Capacitorテーブル全消去
    let fetchRequestCapacitor = NSFetchRequest<NSFetchRequestResult>()
    fetchRequestCapacitor.entity = Capacitor.entity()
    let capacitors = try? context.fetch(fetchRequestCapacitor) as? [Capacitor]
    for capacitor in capacitors! {
        context.delete(capacitor)
    }
    
    
    /// Conductorテーブル全消去
    let fetchRequestConductor = NSFetchRequest<NSFetchRequestResult>()
    fetchRequestConductor.entity = Conductor.entity()
    let conductors = try? context.fetch(fetchRequestConductor) as? [Conductor]
    for conductor in conductors! {
        context.delete(conductor)
    }
    
    /// Categoryテーブル全消去
    let fetchRequestCategory = NSFetchRequest<NSFetchRequestResult>()
    fetchRequestCategory.entity = Category.entity()
    let categories = try? context.fetch(fetchRequestCategory) as? [Category]
    for category in categories! {
        context.delete(category)
    }
    
    /// Capacitorテーブル登録
    for capacitor in capacitorList {
        let newCapacitor = Capacitor(context: context)
        newCapacitor.id = UUID(uuidString: capacitor[0])
        newCapacitor.createdAt = Date()
        newCapacitor.name = capacitor[1]
        newCapacitor.init_balance = Int32(capacitor[2])!
        newCapacitor.balance = Int32(capacitor[2])!
        newCapacitor.settlement = Int16(capacitor[3])!
        newCapacitor.payment = Int16(capacitor[4])!
        
    }
 
    
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd"
    
    /// Flowテーブル登録
    for flow in flowList {
        let newFlow = Flow(context: context)
        
        newFlow.id = UUID()
        newFlow.name = flow[2]
        newFlow.date = format.date(from: flow[5])
        newFlow.createdAt = Date()
//        newFlow.from = UUID(uuidString: flow[0])
//        newFlow.to = UUID(uuidString: flow[1])
        newFlow.amount = Int32(flow[3])!
        newFlow.status = Int16(flow[4])!
        newFlow.from_id = UUID(uuidString: flow[0])
        newFlow.to_id = UUID(uuidString: flow[1])
 
        /// from リレーションの設定
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", UUID(uuidString: flow[0])! as CVarArg)
        
        let result1 = try? context.fetch(fetchRequestCapacitor) as? [Capacitor]
//        print(result1)
        if result1!.count > 0 {
            /// Flow -> Capacitorへのリレーション
            newFlow.from = result1![0]
            result1![0].addToOut_flows(newFlow)
            result1![0].balance -= newFlow.amount
           
        }
        
        /// to リレーションの設定
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", UUID(uuidString: flow[1])! as CVarArg)
        let result2 = try? context.fetch(fetchRequestCapacitor) as? [Capacitor]
        if result2!.count > 0 {
            /// Flow -> Capacitorへのリレーション
            newFlow.to = result2![0]
            result2![0].addToIn_flows(newFlow)
            result2![0].balance += newFlow.amount
           
        }
    }
    
    
    /// Conductorテーブル登録
    for conductor in conductorList {
        let newConductor = Conductor(context: context)
        newConductor.id = UUID()
        newConductor.from_id = UUID(uuidString: conductor[0])
        newConductor.to_id = UUID(uuidString: conductor[1])
        
        newConductor.createdAt = Date()
        
        newConductor.name = conductor[2]
        newConductor.amount = Int32(conductor[3])!
        newConductor.every = Int16(conductor[4])!
        newConductor.span = conductor[5]
        newConductor.day = Int16(conductor[6])!
        newConductor.month = Int16(conductor[7])!
        newConductor.weekday = Int16(conductor[8])!
        newConductor.nextToConduct = Calendar.current.date(byAdding: .day, value: Int.random(in: 1..<10), to: Date())!
        newConductor.category = conductor[9]
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", UUID(uuidString: conductor[0])! as CVarArg)
        
        let result1 = try? context.fetch(fetchRequestCapacitor) as? [Capacitor]

        if result1!.count > 0 {
            /// Conductor -> Capacitorへのリレーション
            newConductor.from = result1![0]
            result1![0].addToOut_conductors(newConductor)
            
           
        }
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", UUID(uuidString: conductor[1])! as CVarArg)
        let result2 = try? context.fetch(fetchRequestCapacitor) as? [Capacitor]

        if result2!.count > 0 {
            /// Conductor -> Capacitorへのリレーション
            newConductor.to = result1![0]
            result2![0].addToIn_conductors(newConductor)
            
           
        }
        
        
        
        
    }
    
    
    for category in categoryList {
        let newCategory = Category(context: context)
        newCategory.id = UUID(uuidString: category[0])
        newCategory.name = category[1]
    }
    
    /// コミット
    try? context.save()
}
 

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "FuseModel")
    
    init(){
        container.loadPersistentStores{ desc, error in
            if let error = error {
                print("Failed to lead the data \(error.localizedDescription)")
            }
            
        }
    }
    
    func save(context: NSManagedObjectContext){
        do {
            try context.save()
            print("Data saved!!! WUHU!!!")
        } catch {
            print("We could not save the data...")
        }
    }
    
    func updateBalance(capacitor: Capacitor, context: NSManagedObjectContext) {
        
        var balance = capacitor.init_balance
        
        let in_flows = flowArray(capacitor.in_flows)
        let out_flows = flowArray(capacitor.out_flows)
        
        
        
        for in_flow in in_flows {
            
            
            if in_flow.status == Status.confirmed.rawValue {
                balance += in_flow.amount
            } 
            
            
        }
        
        for out_flow in out_flows {
            if out_flow.status == Status.confirmed.rawValue {
                balance -= out_flow.amount
            }
           
        }
        
        capacitor.balance = balance
        
        save(context: context)
    }
    
    func makeNotification(title: String, body: String, date: Date) -> UUID {
        
        
        let uuid = UUID()
        
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            
            if granted {
                
                
                        
                print("Set a notification!!")
                let content = UNMutableNotificationContent()
//                content.title = name + " ¥ \(amount)"
//                content.body = note
                content.title = title
                content.body = body
                
                
                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current

                dateComponents.year = Calendar.current.component(.year, from: date)
                dateComponents.month = Calendar.current.component(.month, from: date)
                dateComponents.day = Calendar.current.component(.day, from: date)
                
                dateComponents.hour = 9
                dateComponents.minute = 0
                
            
                   
                // Create the trigger as a repeating event.
                let trigger = UNCalendarNotificationTrigger(
                         dateMatching: dateComponents, repeats: false)
                
                
                
//                newFlow.notification_id = uuid
                
                let uuidString = uuid.uuidString
                let request = UNNotificationRequest(identifier: uuidString,
                            content: content, trigger: trigger)

                // Schedule the request with the system.
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.add(request) { (error) in
                   if error != nil {
                      // Handle any errors.
                       print("An error has occurred!!")
                   }
                }
                
           
            }else {
                //通知が拒否されているときの処理
              
            }
            // Enable or disable features based on the authorization.
        }
        
        return uuid
        
    }
    
    
    func addFlow(name: String, amount: Int32, date: Date, status: Int16, from: UUID, to: UUID, note: String, context: NSManagedObjectContext){
        let newFlow = Flow(context:context)
        newFlow.id = UUID()
        newFlow.createdAt = Date()
        newFlow.amount = amount
        newFlow.date = date
        newFlow.name = name
        newFlow.status = status
        newFlow.from_id = from
        newFlow.to_id = to
        newFlow.note = note
        
        let fetchRequestCapacitor : NSFetchRequest<Capacitor>
        fetchRequestCapacitor = Capacitor.fetchRequest()

        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", from as CVarArg)
        let result1 = try? context.fetch(fetchRequestCapacitor)
        if result1!.count > 0 {
            /// Flow -> Capacitorへのリレーション
            
            newFlow.from = result1![0]
            result1![0].addToOut_flows(newFlow)
            
            
            // いちいちBalanceを全部計算し直すのが嫌になったら復活させるかも
//            if status == Status.confirmed.rawValue {
//                result1![0].balance -= newFlow.amount
//            }
            
        }
        
        /// to リレーションの設定
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", to as CVarArg)
        let result2 = try? context.fetch(fetchRequestCapacitor)
        if result2!.count > 0 {
            /// Flow -> Capacitorへのリレーション
            
            newFlow.to = result2![0]
            result2![0].addToIn_flows(newFlow)
            
            // いちいちBalanceを全部計算し直すのが嫌になったら復活させるかも
//            if status == Status.confirmed.rawValue {
//                result2![0].balance += newFlow.amount
//            }
            
        }
        
        
       
        
        // Confirmedじゃなかった場合、期日に通知
        if status != Status.confirmed.rawValue {
           let uuid = makeNotification(title: name + " ¥ \(amount)", body: note, date: date)
           newFlow.notification_id = uuid
        }
            
            
            
        
        
        
        save(context: context)
        
        updatePaymentConductor(context: context, capacitor: result1![0])
        
        // Capacitorのbalanceをupdate
        updateBalance(capacitor: result1![0], context: context)
        updateBalance(capacitor: result2![0], context: context)
        
    }
    
    
    func editFlow(flow: Flow, name: String, amount: Int32, date: Date,status:Int16,from: UUID, to:UUID, note: String, context: NSManagedObjectContext){
        
        let old_status = flow.status
        let old_from = flow.from_id!
        let old_to = flow.to_id!
//        let old_amount = flow.amount
//        let old_status = flow.status
        flow.date = date
        flow.name = name
        flow.amount = amount
        
        flow.status = status
        flow.from_id = from
        flow.to_id = to
        flow.note = note
        
        
        let fetchRequestCapacitor : NSFetchRequest<Capacitor>
        fetchRequestCapacitor = Capacitor.fetchRequest()
        
        
        // 古いCapacitorとの縁を切る
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", old_from as CVarArg)
        
        let old_from_cap = try? context.fetch(fetchRequestCapacitor)
        
        if old_from_cap!.count > 0 {
            old_from_cap![0].removeFromOut_flows(flow)
            
            
            // いちいちBalanceを全部計算し直すのが嫌になったら復活させるかも
//            if old_status == Status.confirmed.rawValue {
//                old_from_cap![0].balance += old_amount
//            }
           
        }
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", old_to as CVarArg)
        
        let old_to_cap = try? context.fetch(fetchRequestCapacitor)
        
        if old_to_cap!.count > 0 {
            old_to_cap![0].removeFromIn_flows(flow)
            
            
            // いちいちBalanceを全部計算し直すのが嫌になったら復活させるかも
//            if old_status == Status.confirmed.rawValue {
//                old_to_cap![0].balance -= old_amount
//            }
            
        }
        
        // 新しく設定されたCapacitorとの関係を作る
        
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", from as CVarArg)
        let result1 = try? context.fetch(fetchRequestCapacitor)
        if result1!.count > 0 {
            /// Flow -> Capacitorへのリレーション
            flow.from = result1![0]
            result1![0].addToOut_flows(flow)
           
            
            // いちいちBalanceを全部計算し直すのが嫌になったら復活させるかも
//            if status == Status.confirmed.rawValue { // Confirmed -> Confirmed
//                result1![0].balance -= flow.amount
//
//            }
            
            
        }
        
        /// to リレーションの設定
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", to as CVarArg)
        let result2 = try? context.fetch(fetchRequestCapacitor)
        if result2!.count > 0 {
            /// Flow -> Capacitorへのリレーション
            flow.to = result2![0]
            result2![0].addToIn_flows(flow)
        
            
            // いちいちBalanceを全部計算し直すのが嫌になったら復活させるかも
//            if status == Status.confirmed.rawValue { // Confirmed -> Confirmed
//                result2![0].balance += flow.amount
//
//            }
            
            
        }
        
        
        if old_status == Status.confirmed.rawValue{
            if status == Status.confirmed.rawValue {
                // Nothing to do
                
            } else{
                let uuid = makeNotification(title: name + " ¥ \(amount)" , body: note, date: date)
                flow.notification_id = uuid
                
            }
        } else {
            let center = UNUserNotificationCenter.current()
            if flow.notification_id != nil {
                center.removePendingNotificationRequests(withIdentifiers: [flow.notification_id!.uuidString])
            }
           
            
            if status == Status.confirmed.rawValue {
               // Nothing to do
                
            } else{
                let uuid = makeNotification(title: name + " ¥ \(amount)" , body: note, date: date)
                flow.notification_id = uuid
            }
        }
        
    
        

        save(context: context)
        
        updatePaymentConductor(context: context, capacitor: result1![0])
        
        if flow.conductor != nil {
            updateNextToPay(conductor: flow.conductor!, context: context)
        }
        
        
        // Capacitorのbalanceをupdate
        updateBalance(capacitor: old_from_cap![0], context: context)
        updateBalance(capacitor: old_to_cap![0], context: context)
        updateBalance(capacitor: result1![0], context: context)
        updateBalance(capacitor: result2![0], context: context)
        
    }
    
    // Conductorによって生まれたFlowの中ですでにConfirmedになったもの以外のFlowを消す
    func deleteRelevantFlows(conductor: Conductor, context: NSManagedObjectContext){
        let flows = flowArray(conductor.flows)
        
        for flow in flows{
            if flow.status != Status.confirmed.rawValue {
                context.delete(flow)
            }
        }
        
        
        save(context: context)
        
        updateBalance(capacitor: conductor.from!, context: context)
        updateBalance(capacitor: conductor.to!, context: context)
        
    }
    
    func addCapacitor(name:String, init_balance: Int32, type: Int16, settlement: Int16, payment: Int16, from: UUID, context: NSManagedObjectContext){
        let capacitor = Capacitor(context: context)
        capacitor.id = UUID()
        capacitor.createdAt = Date()
        capacitor.name = name
        capacitor.balance = init_balance
        capacitor.init_balance = init_balance
        capacitor.type = type
        capacitor.settlement = settlement
        capacitor.payment = payment
        
//        capacitor.payment_conductor =
        
        
        save(context: context)
        
        
        
        
        if type == CapType.card.rawValue {
            
            let today = Date()
            let month = Calendar.current.component(.month, from: today)
            let day = Calendar.current.component(.day, from: today)
            var component1 = Calendar.current.dateComponents([.year], from: today)
            
            
            if settlement % 31 == 0 {
                component1.month = month + 1
            }
            else if day > settlement {
                
                component1.month = month + 2
            } else {
                component1.month = month + 1
            }
            
            component1.day = Int(payment)
            let next = Calendar.current.date(from:component1)
        
       
            capacitor.payment_conductor = addConductor(name: name+" Payment", amount: 0, from: from , to: capacitor.id! , every: 1, span: "month", day: payment, month: 0, weekday: 0, category: "Uncategorized", nextToPay:next!,  context: context)
            
            save(context: context)
            
        }
    }
    
    func editCapacitor(capacitor: Capacitor, name:String, init_balance: Int32, type: Int16, settlement: Int16, payment: Int16, from: UUID, context: NSManagedObjectContext){
        
        capacitor.name = name
        
        capacitor.init_balance = init_balance
        capacitor.type = type
        capacitor.settlement = settlement
        capacitor.payment = payment
        
        updateBalance(capacitor: capacitor, context: context)
        
        if type == CapType.card.rawValue {
            
            let today = Date()
            let month = Calendar.current.component(.month, from: today)
            let day = Calendar.current.component(.day, from: today)
            var component1 = Calendar.current.dateComponents([.year], from: today)
            
            
            if settlement % 31 == 0 {
                component1.month = month + 1
            }
            else if day > settlement {
                
                component1.month = month + 2
            } else {
                component1.month = month + 1
            }
            
            component1.day = Int(payment)
            let next = Calendar.current.date(from:component1)
        
            
            
            
            let old_payment_conductor = capacitor.payment_conductor!
            let from_cap = old_payment_conductor.from
            let to_cap = old_payment_conductor.to
            
//            let flows = flowArray(old_payment_conductor.flows)
//
//            for flow in flows {
//                context.delete(flow)
//            }
            
            
            //新たにpayment_conductorを作る
            capacitor.payment_conductor = addConductor(name: name+" Payment", amount: 0, from: from , to: capacitor.id! , every: 1, span: "month", day: payment, month: 0, weekday: 0, category: old_payment_conductor.category!, nextToPay:next!,  context: context)
            
            // すでにConfirmedになったFlowは消さない。それ以外を消す。
            deleteRelevantFlows(conductor: old_payment_conductor, context: context)
            // 既存のpayment_conductorを消す
            context.delete(old_payment_conductor)
            
            updateBalance(capacitor: from_cap!, context: context)
            updateBalance(capacitor: to_cap!, context: context)
            
            
            
            
            
            save(context: context)
            
            // あとのupdatePaymentConductorの操作対象を作るために、Flowを実体化する
            applyConductors(context: context)
            updatePaymentConductor(context: context, capacitor: capacitor)
            
            
            
           
        }
        
    }
    
    func addConductor(name: String, amount: Int32, from: UUID, to:UUID, every: Int16, span: String, day: Int16, month:Int16, weekday: Int16, category: String, nextToPay: Date, context: NSManagedObjectContext) -> Conductor {
        
      
        
        let conductor = Conductor(context: context)
        conductor.id = UUID()
        conductor.createdAt = Date()
        conductor.name = name
        conductor.amount = amount
        conductor.from_id = from
        conductor.to_id = to
        conductor.every = every
        conductor.span = span
        conductor.day = day
        conductor.month = month
        conductor.weekday = weekday
        conductor.nextToConduct = nextToPay
        conductor.nextToPay = nextToPay
        conductor.category = category
        
        
        
        let fetchRequestCapacitor : NSFetchRequest<Capacitor>
        fetchRequestCapacitor = Capacitor.fetchRequest()
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@",from as CVarArg)
        
        let result1 = try? context.fetch(fetchRequestCapacitor)

        if result1!.count > 0 {
            /// Conductor -> Capacitorへのリレーション
            
            conductor.from = result1![0]
            result1![0].addToOut_conductors(conductor)
            
           
        }
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", to as CVarArg)
        let result2 = try? context.fetch(fetchRequestCapacitor)

        if result2!.count > 0 {
            /// Conductor -> Capacitorへのリレーション
            conductor.to = result2![0]
            result2![0].addToIn_conductors(conductor)
           
        }
        
        save(context: context)
        
        return conductor
        
    }
    
    func editConductor(conductor: Conductor, name: String, amount: Int32, from: UUID, to: UUID, every: Int16, span: String, day: Int16, month: Int16, weekday: Int16, category: String, nextToPay: Date, context: NSManagedObjectContext){
        
        print("every: \(every)")
        print("span: \(span)")
        print("month: \(month)")
        print("day: \(day)")
        print("weekday: \(weekday)")
        print("category: \(category)")
        print("nextToPay: \(nextToPay)")
        
        deleteRelevantFlows(conductor: conductor, context: context)
        
        let old_from = conductor.from_id!
        let old_to = conductor.to_id!
        
        conductor.name = name
        conductor.amount = amount
        conductor.from_id = from
        conductor.to_id = to
        conductor.every = every
        conductor.span = span
        conductor.day = day
        conductor.month = month
        conductor.weekday = weekday
        conductor.category = category
        conductor.nextToPay = nextToPay
        conductor.nextToConduct = nextToPay
        
        
        
        
        let fetchRequestCapacitor : NSFetchRequest<Capacitor>
        fetchRequestCapacitor = Capacitor.fetchRequest()
        
        
        // もともとあったrelationの削除
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@",old_from as CVarArg)
        let result1 = try? context.fetch(fetchRequestCapacitor)
        
        if result1!.count > 0 {
            result1![0].removeFromOut_conductors(conductor)
        }
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@",old_to as CVarArg)
        let result2 = try? context.fetch(fetchRequestCapacitor)
        
        if result2!.count > 0 {
            result2![0].removeFromIn_conductors(conductor)
        }
        
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@",from as CVarArg)
        
        let result3 = try? context.fetch(fetchRequestCapacitor)

        if result3!.count > 0 {
            /// Conductor -> Capacitorへのリレーション
            
            conductor.from = result3![0]
            result3![0].addToOut_conductors(conductor)
           
           
        }
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", to as CVarArg)
        let result4 = try? context.fetch(fetchRequestCapacitor)

        if result4!.count > 0 {
            /// Conductor -> Capacitorへのリレーション
            conductor.to = result4![0]
            result4![0].addToIn_conductors(conductor)
           
        }
        
        
        
        
//        let nearest = nearestFlow(conductor: conductor)
//
//        if nearest != nil {
//            nearest!.date = nextToPay
//        }
        
        
        
       
        save(context: context)
        
        
        
    }
    
    func addCategory(name: String, context: NSManagedObjectContext){
        let category = Category(context: context)
        category.id = UUID()
        
        category.createdAt = Date()
        category.name = name
        
        
        
        
        save(context: context)
    }
    
    // Capacitor内で、ConductorにとってのNextのdateが変更されたら、それをConductorのnextToPayに反映
    func updateNextToPay(conductor: Conductor, context:NSManagedObjectContext ){
        
        
        let nearest = nearestComingPayment(conductor: conductor)
        conductor.nextToPay = nearest
        
        save(context: context)
    }
    
    // 毎秒実行
    // 来月の末日までにConductorのnextToConductが入っていたら、Conductorの内容をFlowとして実体化する
    func applyConductors(context: NSManagedObjectContext){
        
        let fetchRequestConductor : NSFetchRequest<Conductor>
        fetchRequestConductor = Conductor.fetchRequest()
        
        let today = Date()
        
        let this_month = Calendar.current.component(.month, from: today)
        
        
        var component = NSCalendar.current.dateComponents([.year], from: today)
        component.month = this_month + 2
        component.day = 1
        component.hour = 0
        component.minute = 0
        component.second = 0
        
        let the_end_of_the_next_month:NSDate = NSCalendar.current.date(from:component)! as NSDate
        
        
       
        
        
        
        fetchRequestConductor.predicate = NSPredicate(format: "nextToConduct <= %@",the_end_of_the_next_month as CVarArg)
        let results = try? context.fetch(fetchRequestConductor)
        
        
        if results!.count > 0 {
            
            print("Found a conductor!!")
            for conductor in results! {
                let newFlow = Flow(context:context)
                newFlow.id = UUID()
                newFlow.createdAt = Date()
                newFlow.amount = conductor.amount
                newFlow.date = conductor.nextToConduct
                newFlow.name = conductor.name
                newFlow.status = Int16(Status.coming.rawValue)
                newFlow.from_id = conductor.from_id
                newFlow.to_id = conductor.to_id
                
                let fetchRequestCapacitor : NSFetchRequest<Capacitor>
                fetchRequestCapacitor = Capacitor.fetchRequest()

                
                fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", conductor.from_id! as CVarArg)
                let result1 = try? context.fetch(fetchRequestCapacitor)
                if result1!.count > 0 {
                    /// Flow -> Capacitorへのリレーション
                    
                    newFlow.from = result1![0]
                    result1![0].addToOut_flows(newFlow)

                }
                
                /// to リレーションの設定
                fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", conductor.to_id! as CVarArg)
                let result2 = try? context.fetch(fetchRequestCapacitor)
                if result2!.count > 0 {
                    /// Flow -> Capacitorへのリレーション
                    
                    newFlow.to = result2![0]
                    result2![0].addToIn_flows(newFlow)

                }
                
                // Flow と Conductorのリレーションの設定
                newFlow.conductor = conductor
                conductor.addToFlows(newFlow)
//                print("every: \(conductor.every)")
//                print("span: \(conductor.span!)")
//                print("day: \(conductor.day)")
//                print("month: \(conductor.month)")
//                print("weekday: \(conductor.weekday)")
                
                conductor.nextToConduct = calcNext(previous: conductor.nextToConduct!, every: Int(conductor.every), span: conductor.span!, on_day: Int(conductor.day), on_month: Int(conductor.month), on_weekday: Int(conductor.weekday))
                
//                print(conductor.next!)
                
                
            }
        }
        
        
        
        
    }
    
    //そのCapacitorのstartからendまでのFlowの合計金額を返す
    private func total_flows(start: Date, end: Date, capacitor: Capacitor, context: NSManagedObjectContext) -> Int32 {
        var sum: Int32 = 0
        
        var component1 = NSCalendar.current.dateComponents([.year,.month,.day], from: start)
        
        component1.hour = 0
        component1.minute = 0
        component1.second = 0
        
        let start:NSDate = NSCalendar.current.date(from:component1)! as NSDate
        
        var component2 = NSCalendar.current.dateComponents([.year,.month,.day], from: end)
        
        component2.day = component2.day! + 1
        component2.hour = 0
        component2.minute = 0
        component2.second = 0
        
        let fetchRequestFlow : NSFetchRequest<Flow>
        fetchRequestFlow = Flow.fetchRequest()
        
        fetchRequestFlow.predicate = NSPredicate(format: "date >= %@ && date < %@ && from_id = %@", start as CVarArg, end as CVarArg, capacitor.id! as CVarArg)
        
        let out_flows = try? context.fetch(fetchRequestFlow)
        
        
        
        for out_flow in out_flows! {
            if out_flow.to!.id! == outside_id {
                if out_flow.status != Status.pending.rawValue {
                    sum -= out_flow.amount
                }
            
            }
        }
        
        fetchRequestFlow.predicate = NSPredicate(format: "date >= %@ && date < %@ && to_id = %@", start as CVarArg, end as CVarArg, capacitor.id! as CVarArg)
        
        let in_flows = try? context.fetch(fetchRequestFlow)
        
        for in_flow in in_flows! {
            if in_flow.from!.id! == outside_id {
                if in_flow.status != Status.pending.rawValue {
                    sum += in_flow.amount
                }
            }
        }
        
        return sum
        
        
    
        
        
    }
    
    
    // flowが追加、あるいはそのamountが編集されたら、payment_conductorの値を更新するための関数
    func updatePaymentConductor(context: NSManagedObjectContext, capacitor: Capacitor) {
        
        
        if capacitor.type == CapType.card.rawValue {
            
            
            let payment_conductor = capacitor.payment_conductor!
            if payment_conductor.flows!.count > 0 {
                
                let payment_flows = flowArray(payment_conductor.flows!)
                
                for (index,payment_flow) in payment_flows.enumerated() {
                    
                    var component = Calendar.current.dateComponents([.year,.month,.day], from: payment_flow.date!)
                    
                    let year = Calendar.current.component(.year, from: payment_flow.date!)
                    
                    let payment_month = component.month!
                    
                    
                    var start_settlement = capacitor.settlement
                    var end_settlement = capacitor.settlement
                    // last だったら
                    if capacitor.settlement % 31 == 0 {
                        
                        start_settlement = Int16(lastDay(year: year, month: payment_month - 2))
                        
                        end_settlement = Int16(lastDay(year:year, month: payment_month - 1))
                    }
                    
                    
                    component.month = payment_month - 2
                    
                    component.day = Int(start_settlement) + 1
                    
                    let start = Calendar.current.date(from: component)
                    
                    component.month = payment_month - 1
                    component.day = Int(end_settlement)
                    
                    let end = Calendar.current.date(from: component)
                    
                    
                    let new_amount = total_flows(start:start! , end: end!, capacitor: capacitor, context: context)
                    
                    payment_flow.amount = -new_amount
                    
                    if index == 0 {
                        payment_conductor.amount = -new_amount
                    }
                }
                
                save(context: context)
            }
            
        }
    }
    
    func togglePending(flow: Flow, context: NSManagedObjectContext){
        
        if flow.status == Status.pending.rawValue {
            flow.status = Int16(Status.tentative.rawValue)
        } else if flow.status == Status.tentative.rawValue {
            flow.status = Int16(Status.pending.rawValue)
        }
        
        
        if flow.from != nil {
            
        
            if flow.from!.type == CapType.card.rawValue {
                updatePaymentConductor(context: context, capacitor: flow.from!)
            } else if flow.to!.type == CapType.card.rawValue {
                updatePaymentConductor(context: context, capacitor: flow.to!)
            }
            
            updateBalance(capacitor:flow.from! , context: context)
            updateBalance(capacitor: flow.to!, context: context)
            
        }
        
        save(context: context)
    }
    
    func toggleComing(flow: Flow, context: NSManagedObjectContext){
        if flow.status == Status.coming.rawValue {
            flow.status = Int16(Status.confirmed.rawValue)
        } else if flow.status == Status.confirmed.rawValue {
            flow.status = Int16(Status.coming.rawValue)
        }
        
        
        if flow.from != nil {
            
        
            if flow.from!.type == CapType.card.rawValue {
                updatePaymentConductor(context: context, capacitor: flow.from!)
            } else if flow.to!.type == CapType.card.rawValue {
                updatePaymentConductor(context: context, capacitor: flow.to!)
            }
            
            updateBalance(capacitor:flow.from! , context: context)
            updateBalance(capacitor: flow.to!, context: context)
            
        }
        
        save(context: context)
        
        
    }
    
    
}
