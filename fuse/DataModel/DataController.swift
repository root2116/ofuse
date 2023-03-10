//
//  DataController.swift
//  fuse
//
//  Created by araragi943 on 2022/06/09.
//

import Foundation
import CoreData
import SwiftUI




func init_cap(context: NSManagedObjectContext, capId: UUID, capName: String){
    print("\(capName): \(capId.uuidString)")
//    let fetchRequestCurrent = NSFetchRequest<NSFetchRequestResult>()
//    fetchRequestCurrent.entity = Current.entity()
//    let currents = try? context.fetch(fetchRequestCurrent) as? [Current]
//
//    for current in currents! {
//        if current.charges!.count > 0 {
//            print("\(current.name!) has charges")
//        }else {
//            print("\(current.name!) doesn't have charges")
//        }
//
//    }
//
//    / Capacitorテーブル全消去
//    let fetchRequestCapacitor = NSFetchRequest<NSFetchRequestResult>()
//    fetchRequestCapacitor.entity = Capacitor.entity()
//    let capacitors = try? context.fetch(fetchRequestCapacitor) as? [Capacitor]
//    for capacitor in capacitors! {
//        context.delete(capacitor)
//    }
//
        
    let fetchRequestCapacitor = NSFetchRequest<NSFetchRequestResult>()
    fetchRequestCapacitor.entity = Capacitor.entity()
    guard let capacitors = try? context.fetch(fetchRequestCapacitor) as? [Capacitor] else {
        print("Failed to fetch capacitors")
        return
    }
    
   
    for capacitor in capacitors {
        if capacitor.id == capId {
            return
        }
    }
    
    
   
    let newCapacitor = Capacitor(context: context)
    newCapacitor.id = capId
    newCapacitor.createdAt = Date()
    newCapacitor.name = capName
    newCapacitor.balance = 0
    
    
    

    try? context.save()
    
}

func init_cat(context: NSManagedObjectContext, catId: UUID, catName: String){
  
    
    let fetchRequestCategory = NSFetchRequest<NSFetchRequestResult>()
    fetchRequestCategory.entity = Category.entity()
    
    
    var hasUncategorized = false
    let categories = try? context.fetch(fetchRequestCategory) as? [Category]
    
//    for category in categories! {
//        context.delete(category)
//    }
    if categories!.count > 0 {
        for category in categories! {
            if category.name == catName {
                hasUncategorized = true
            }
        }
    }
    
    if hasUncategorized == false {
        let newCategory = Category(context: context)
        newCategory.id = catId
        newCategory.createdAt = Date()
        newCategory.name =  catName
    }
    
    try? context.save()
}

func init_tag(context: NSManagedObjectContext) {
    
    // Untaggedというタグが存在しなければ追加する
    let fetchRequestTag = NSFetchRequest<NSFetchRequestResult>()
    fetchRequestTag.entity = Tag.entity()
    
    
    var hasUntagged = false
    let tags = try? context.fetch(fetchRequestTag) as? [Tag]
    if tags!.count > 0 {
        for tag in tags! {
            if tag.name == "Untagged" {
                hasUntagged = true
            }
        }
    }
    
    if hasUntagged == false {
        let newTag = Tag(context: context)
        newTag.id = UUID()
        newTag.createdAt = Date()
        newTag.name = "Untagged"
    }
    
    try? context.save()
    
}

func initCoreData(context: NSManagedObjectContext){
        let fetchRequestCapacitor = NSFetchRequest<NSFetchRequestResult>()
        fetchRequestCapacitor.entity = Capacitor.entity()
        let capacitors = try? context.fetch(fetchRequestCapacitor) as? [Capacitor]
        for capacitor in capacitors! {
            context.delete(capacitor)
        }
        
        let fetchRequestCharge = NSFetchRequest<NSFetchRequestResult>()
        fetchRequestCharge.entity = Charge.entity()
        let charges = try? context.fetch(fetchRequestCharge) as? [Charge]
        for charge in charges! {
            context.delete(charge)
        }
        
        let fetchRequestCurrent = NSFetchRequest<NSFetchRequestResult>()
        fetchRequestCurrent.entity = Current.entity()
        let currents = try? context.fetch(fetchRequestCurrent) as? [Current]
        for current in currents! {
            context.delete(current)
        }
        
        let fetchRequestTag = NSFetchRequest<NSFetchRequestResult>()
        fetchRequestTag.entity = Tag.entity()
        let tags = try? context.fetch(fetchRequestTag) as? [Tag]
        for tag in tags! {
            context.delete(tag)
        }
    
        DataController().save(context: context)
    
    
}
//func registSampleData(context: NSManagedObjectContext) {
//
//    print("Register!!")
//
//    let outside_id = "CE130F1C-3B2F-42CA-8339-1549531E0102"
//    let bank_id = UUID().uuidString
//    let credit_id = UUID().uuidString
//
//
//    let subscription_id = UUID().uuidString
//    let uncategorized_id = UUID().uuidString
//
//    let tagList = [[uncategorized_id,"Uncategorized"],[subscription_id,"Subscription"]]
//
//    print("Outside: \(outside_id)")
//    print("Bank: \(bank_id)")
//    print("Credit: \(credit_id)")
//    /// Chargeテーブル初期値
//    let chargeList = [
//        [bank_id,outside_id,"お菓子","200","0","2022-08-14"],
//        [bank_id,outside_id,"雑誌","2200","0","2022-08-14"],
//        [credit_id,outside_id,"本","3000","0", "2022-09-10"],
//        [credit_id,outside_id,"チケット","10000","0","2022-09-12"],
//        [outside_id,bank_id,"給料","20000","0","2022-10-11"]
//    ]
//
//    /// Capacitorテーブル初期値
//    let capacitorList = [
//        [outside_id,"Outside", "0","0","0"],
//        [bank_id,"Bank", "10000","0","0"],
//        [credit_id,"Credit Card", "10000","10","2"]
//    ]
//
//
//    /// 0は*, -1は月末を表す
//    let currentList = [
//        // from_id, to_id, name, amount,every,span, day, month, weekday, tag
//        [credit_id,outside_id,"日向坂ファンクラブ","440","1","month","25","0","0","Subscription"]
//
//    ]
//
//    /// Chargeテーブル全消去
//    let fetchRequestCharge = NSFetchRequest<NSFetchRequestResult>()
//    fetchRequestCharge.entity = Charge.entity()
//    let charges = try? context.fetch(fetchRequestCharge) as? [Charge]
//    for charge in charges! {
//        context.delete(charge)
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
//    /// Currentテーブル全消去
//    let fetchRequestCurrent = NSFetchRequest<NSFetchRequestResult>()
//    fetchRequestCurrent.entity = Current.entity()
//    let currents = try? context.fetch(fetchRequestCurrent) as? [Current]
//    for current in currents! {
//        context.delete(current)
//    }
//
//    /// Tagテーブル全消去
//    let fetchRequestTag = NSFetchRequest<NSFetchRequestResult>()
//    fetchRequestTag.entity = Tag.entity()
//    let tags = try? context.fetch(fetchRequestTag) as? [Tag]
//    for tag in tags! {
//        context.delete(tag)
//    }
//
//    /// Capacitorテーブル登録
//    for capacitor in capacitorList {
//        let newCapacitor = Capacitor(context: context)
//        newCapacitor.id = UUID(uuidString: capacitor[0])
//        newCapacitor.createdAt = Date()
//        newCapacitor.name = capacitor[1]
//        newCapacitor.init_balance = Int32(capacitor[2])!
//        newCapacitor.balance = Int32(capacitor[2])!
//        newCapacitor.settlement = Int16(capacitor[3])!
//        newCapacitor.payment = Int16(capacitor[4])!
//
//    }
//
//
//    let format = DateFormatter()
//    format.dateFormat = "yyyy-MM-dd"
//
//    /// Chargeテーブル登録
//    for charge in chargeList {
//        let newCharge = Charge(context: context)
//
//        newCharge.id = UUID()
//        newCharge.name = charge[2]
//        newCharge.date = format.date(from: charge[5])
//        newCharge.createdAt = Date()
////        newCharge.from = UUID(uuidString: charge[0])
////        newCharge.to = UUID(uuidString: charge[1])
//        newCharge.amount = Int32(charge[3])!
//        newCharge.status = Int16(charge[4])!
//        newCharge.from_id = UUID(uuidString: charge[0])
//        newCharge.to_id = UUID(uuidString: charge[1])
//
//        /// from リレーションの設定
//
//        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", UUID(uuidString: charge[0])! as CVarArg)
//
//        let result1 = try? context.fetch(fetchRequestCapacitor) as? [Capacitor]
////        print(result1)
//        if result1!.count > 0 {
//            /// Charge -> Capacitorへのリレーション
//            newCharge.from = result1![0]
//            result1![0].addToOut_charges(newCharge)
//            result1![0].balance -= newCharge.amount
//
//        }
//
//        /// to リレーションの設定
//        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", UUID(uuidString: charge[1])! as CVarArg)
//        let result2 = try? context.fetch(fetchRequestCapacitor) as? [Capacitor]
//        if result2!.count > 0 {
//            /// Charge -> Capacitorへのリレーション
//            newCharge.to = result2![0]
//            result2![0].addToIn_charges(newCharge)
//            result2![0].balance += newCharge.amount
//
//        }
//    }
//
//
//    /// Currentテーブル登録
//    for current in currentList {
//        let newCurrent = Current(context: context)
//        newCurrent.id = UUID()
//        newCurrent.from_id = UUID(uuidString: current[0])
//        newCurrent.to_id = UUID(uuidString: current[1])
//
//        newCurrent.createdAt = Date()
//
//        newCurrent.name = current[2]
//        newCurrent.amount = Int32(current[3])!
//        newCurrent.every = Int16(current[4])!
//        newCurrent.span = current[5]
//        newCurrent.day = Int16(current[6])!
//        newCurrent.month = Int16(current[7])!
//        newCurrent.weekday = Int16(current[8])!
////        newCurrent.nextToConduct = Calendar.charge.date(byAdding: .day, value: Int.random(in: 1..<10), to: Date())!
//        newCurrent.tag = current[9]
//
//        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", UUID(uuidString: current[0])! as CVarArg)
//
//        let result1 = try? context.fetch(fetchRequestCapacitor) as? [Capacitor]
//
//        if result1!.count > 0 {
//            /// Current -> Capacitorへのリレーション
//            newCurrent.from = result1![0]
//            result1![0].addToOut_currents(newCurrent)
//
//
//        }
//
//        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", UUID(uuidString: current[1])! as CVarArg)
//        let result2 = try? context.fetch(fetchRequestCapacitor) as? [Capacitor]
//
//        if result2!.count > 0 {
//            /// Current -> Capacitorへのリレーション
//            newCurrent.to = result1![0]
//            result2![0].addToIn_currents(newCurrent)
//
//
//        }
//
//
//
//
//    }
//
//
//    for tag in tagList {
//        let newTag = Tag(context: context)
//        newTag.id = UUID(uuidString: tag[0])
//        newTag.name = tag[1]
//    }
//
//    /// コミット
//    try? context.save()
//}
//

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
                
                
                
                //                newCharge.notification_id = uuid
                
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
    
    func predCharge(targetCharge: Charge, capId: UUID, context:NSManagedObjectContext) -> Charge? {
        let fetchRequestCharge : NSFetchRequest<Charge>
        fetchRequestCharge = Charge.fetchRequest()
        
        fetchRequestCharge.predicate = NSPredicate(format: "from_id == %@ || to_id == %@", capId as CVarArg, capId as CVarArg)
        
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let createdAtSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        
        fetchRequestCharge.sortDescriptors = [dateSortDescriptor, createdAtSortDescriptor]
        
        let charges = try? context.fetch(fetchRequestCharge)
            
        if charges!.count > 0 {
            for charge in charges! {
                
                
                if charge.date! < targetCharge.date! {
                    return charge
                } else if charge.date! == targetCharge.date! {
                    if charge.createdAt! < targetCharge.createdAt! {
                        return charge
                    }
                }
                
            }
        }
        
        return nil
    }
    
    func nextCharge(targetCharge: Charge, capId: UUID, context:NSManagedObjectContext) -> Charge? {
        let fetchRequestCharge : NSFetchRequest<Charge>
        fetchRequestCharge = Charge.fetchRequest()
        
        fetchRequestCharge.predicate = NSPredicate(format: "from_id == %@ || to_id == %@", capId as CVarArg, capId as CVarArg)
        
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let createdAtSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        
        fetchRequestCharge.sortDescriptors = [dateSortDescriptor, createdAtSortDescriptor]
        
        let charges = try? context.fetch(fetchRequestCharge)
        
        if charges!.count > 0 {
        
            for charge in charges! {
                if charge.date! > targetCharge.date! {
                    return charge
                } else if charge.date! == targetCharge.date! {
                    if charge.createdAt! > targetCharge.createdAt! {
                        return charge
                    }
                }
                
            }
        }
        
        return nil
    }
    
    func updateBalances(charge: Charge, from: UUID, to: UUID){
        var from_after = charge.from_next
        var from_after_pred = charge
        var to_after = charge.to_next
        var to_after_pred = charge
        
        if from_after == nil {
            return
        }
        
        
        // 後続のchargeのfrom_balanceとto_balanceを更新する
        while from_after != nil {
            
            
            if from_after!.from_id == from {
                if from_after!.status != Status.pending.rawValue {
                    from_after!.from_balance = from_after_pred.from_balance - from_after!.amount
                } else {
                    from_after!.from_balance = from_after_pred.from_balance
                }
                from_after_pred = from_after!
                from_after = from_after!.from_next
            } else {
                if from_after!.status != Status.pending.rawValue {
                    from_after!.to_balance = from_after_pred.from_balance + from_after!.amount
                } else {
                    from_after!.to_balance = from_after_pred.from_balance
                }
                from_after_pred = from_after!
                from_after = from_after!.to_next
            }
        }
        
        if to_after == nil {
            return
        }
        
        while to_after != nil {
            if to_after!.to_id == to {
                if to_after!.status != Status.pending.rawValue {
                    to_after!.to_balance = to_after_pred.to_balance - to_after!.amount
                } else {
                    to_after!.to_balance = to_after_pred.to_balance
                }
                to_after_pred = to_after!
                to_after = to_after!.to_next
            } else {
                if to_after!.status != Status.pending.rawValue {
                    to_after!.from_balance = to_after_pred.to_balance + to_after!.amount
                } else {
                    to_after!.from_balance = to_after_pred.to_balance
                }
                to_after_pred = to_after!
                to_after = to_after!.from_next
            }
        }
        
    }
    
    func extractHashtags(from text: String) -> [String] {
        // 正規表現パターンでハッシュタグを検索
        let pattern = "(?<=#)[^#\\s]+"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }
        let range = NSRange(text.startIndex..., in: text)
        // マッチするハッシュタグの範囲を取得
        let matches = regex.matches(in: text, range: range)
        // マッチしたハッシュタグの文字列を配列に格納
        let hashtags = matches.map {
            String(text[Range($0.range, in: text)!])
        }
        return hashtags
    }
    
    func updateVariableCharge(context: NSManagedObjectContext){
        let fetchRequestCharge : NSFetchRequest<Charge>
        fetchRequestCharge = Charge.fetchRequest()
        
        fetchRequestCharge.predicate = NSPredicate(format: "is_variable == %@", NSNumber(value: true))
        let charges = try? context.fetch(fetchRequestCharge)
        
        if charges!.count > 0 {
            
            for charge in charges!{
                let newAmount = calcAmount(start: charge.start!, end: charge.end!, from: charge.vfrom_id!, to: charge.vto_id!, context: context)
                if newAmount != charge.amount {
                    editCharge(charge: charge, name: charge.name ?? "", amount: Int32(newAmount), date: charge.date!, status: charge.status, from: charge.from_id!, to: charge.to_id!, note: charge.note ?? "", included: charge.included, is_variable: charge.is_variable, start: charge.start ?? Date(), end: charge.end ?? Date(), vfrom_id: charge.vfrom_id!, vto_id: charge.vto_id!, category: charge.category?.id ?? uncatId!, context: context)
                }
            }
        }
        
        
    }
    
    
    func allCharges(capId: UUID, context: NSManagedObjectContext) -> [Charge] {
        let fetchRequestCharge : NSFetchRequest<Charge>
        fetchRequestCharge = Charge.fetchRequest()
        
        fetchRequestCharge.predicate = NSPredicate(format: "from_id == %@ || to_id == %@", capId as CVarArg, capId as CVarArg)
        
        fetchRequestCharge.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true), NSSortDescriptor(key: "createdAt", ascending: true)]
        
        let result = try? context.fetch(fetchRequestCharge)
        
        return result ?? []
        
    }
    
    func updateChargeBalances(capId: UUID, context: NSManagedObjectContext){
        
        let charges = allCharges(capId: capId, context: context)
        
        var balance = 0
        for charge in charges{
            if charge.from_id! == capId {
                if charge.status != Status.pending.rawValue {
                    balance = balance - Int(charge.amount)
                    charge.from_balance = Int32(balance)
                }
            } else {
                if charge.status != Status.pending.rawValue {
                    balance = balance + Int(charge.amount)
                    charge.to_balance = Int32(balance)
                }
            }
        }
        
       
        
    }
    
    func addCharge(name: String, amount: Int32, date: Date, status: Int16, from: UUID, to: UUID, note: String, included: Bool, is_variable: Bool, start: Date, end: Date, vfrom_id: UUID, vto_id: UUID, category: UUID, context: NSManagedObjectContext) -> Charge {
        let newCharge = Charge(context:context)
        
        newCharge.id = UUID()
        newCharge.createdAt = Date()
        newCharge.amount = amount
        newCharge.date = date
        newCharge.name = name
        newCharge.status = status
        newCharge.from_id = from
        newCharge.to_id = to
        newCharge.note = note
        newCharge.included = included
        newCharge.is_variable = is_variable
        newCharge.start = start
        newCharge.end = end
        newCharge.vfrom_id = vfrom_id
        newCharge.vto_id = vto_id
        
        
        let fetchRequestCategory: NSFetchRequest<Category>
        fetchRequestCategory = Category.fetchRequest()
        
        fetchRequestCategory.predicate = NSPredicate(format: "id == %@", category as CVarArg)
        let result = try? context.fetch(fetchRequestCategory)
        
        if result!.count > 0 {
            newCharge.category = result![0]
        }
        
        
        
        
        let tags = extractHashtags(from: note)
        
        let fetchRequestTag : NSFetchRequest<Tag>
        fetchRequestTag = Tag.fetchRequest()
        
        for tag in tags {
            fetchRequestTag.predicate = NSPredicate(format: "name == %@", tag as CVarArg)
            let result = try? context.fetch(fetchRequestTag)
            
            if result!.count > 0 {
                newCharge.addToTags(result![0])
            } else {
                let newTag = Tag(context: context)
                newTag.id = UUID()
                newTag.createdAt = Date()
                newTag.name = tag
                newCharge.addToTags(newTag)
                
            }
            
        }
        
        
        // 次のchargeのpredにnewChargeを登録する(chargeの間に挿入する場合)
        
        
//        if let from_pred = predCharge(targetCharge: newCharge, capId: from, context: context) {
//            newCharge.from_pred = from_pred
//            if from_pred.from_id == from {
//                from_pred.from_next = newCharge
//            } else {
//                from_pred.to_next = newCharge
//            }
//        }
//
//        if let from_next = nextCharge(targetCharge: newCharge, capId: from, context: context) {
//            newCharge.from_next = from_next
//            if from_next.from_id == from {
//                from_next.from_pred = newCharge
//            } else {
//                from_next.to_pred = newCharge
//            }
//        }
//        if let to_pred = predCharge(targetCharge: newCharge, capId: to, context: context){
//            newCharge.to_pred = to_pred
//            if to_pred.to_id == to {
//                to_pred.to_next = newCharge
//            } else {
//                to_pred.from_next = newCharge
//            }
//        }
//        if let to_next = nextCharge(targetCharge: newCharge, capId: to, context: context){
//            newCharge.to_next = to_next
//            if to_next.to_id == to {
//                to_next.to_pred = newCharge
//            } else {
//                to_next.from_pred = newCharge
//            }
//        }
//



        
        // newChargeのbalanceをpredから計算
        
//
//        if newCharge.status != Status.pending.rawValue || newCharge.included {
//
//            if let from_pred = newCharge.from_pred {
//                newCharge.from_balance = (from_pred.from_id == from) ? (from_pred.from_balance) - amount : (from_pred.to_balance) - amount
//            } else {
//                newCharge.from_balance = -amount
//            }
//
//            if let to_pred = newCharge.to_pred {
//                newCharge.to_balance = (to_pred.to_id == to) ? (to_pred.to_balance) + amount : (to_pred.from_balance) + amount
//            } else {
//                newCharge.to_balance = amount
//            }
//        }
//
        
        
        
        
        
        
//        updateBalances(charge: newCharge, from: from, to: to)
        
        let fetchRequestCapacitor : NSFetchRequest<Capacitor>
        fetchRequestCapacitor = Capacitor.fetchRequest()
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", from as CVarArg)
        let result1 = try? context.fetch(fetchRequestCapacitor)
        if result1!.count > 0 {
            /// Charge -> Capacitorへのリレーション
            
            newCharge.from = result1![0]
            result1![0].addToOut_charges(newCharge)
            
            
            if status == Status.confirmed.rawValue {
                result1![0].balance -= newCharge.amount
            }
            
        }
        
        /// to リレーションの設定
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", to as CVarArg)
        let result2 = try? context.fetch(fetchRequestCapacitor)
        if result2!.count > 0 {
            /// Charge -> Capacitorへのリレーション
            
            newCharge.to = result2![0]
            result2![0].addToIn_charges(newCharge)
            
            
            if status == Status.confirmed.rawValue {
                result2![0].balance += newCharge.amount
            }
            
        }
        
        
        // Confirmedじゃなかった場合、期日に通知
        if status != Status.confirmed.rawValue {
            let uuid = makeNotification(title: name + " ¥ \(amount)", body: note, date: date)
            newCharge.notification_id = uuid
        }
        
        updateVariableCharge(context: context)
        
        
        save(context: context)
        
        updateChargeBalances(capId: from, context: context)
        updateChargeBalances(capId: to, context: context)
        
        save(context: context)
        
        return newCharge
    }
    
    
    func editCharge(charge: Charge, name: String, amount: Int32, date: Date,status:Int16,from: UUID, to:UUID, note: String, included: Bool, is_variable: Bool, start: Date, end: Date, vfrom_id: UUID, vto_id: UUID, category: UUID, context: NSManagedObjectContext){
        
        let old_status = charge.status
        let old_from = charge.from_id!
        let old_to = charge.to_id!
        let old_amount = charge.amount
        
        
        charge.date = date
        charge.name = name
        charge.amount = amount
        
        charge.status = status
        charge.from_id = from
        charge.to_id = to
        charge.note = note
        charge.included = included
        charge.is_variable = is_variable
        charge.start = start
        charge.end = end
        charge.vfrom_id = vfrom_id
        charge.vto_id = vto_id
        
        
        let fetchRequestCategory: NSFetchRequest<Category>
        fetchRequestCategory = Category.fetchRequest()
        
        fetchRequestCategory.predicate = NSPredicate(format: "id == %@", category as CVarArg)
        let result = try? context.fetch(fetchRequestCategory)
        
        if result!.count > 0 {
            charge.category = result![0]
        }
        
        let str_tags = extractHashtags(from: note)
        
        let fetchRequestTag : NSFetchRequest<Tag>
        fetchRequestTag = Tag.fetchRequest()
        
        let old_tags = charge.tags
        
        // 古いTagを全部消す
        for old_tag in tagArray(old_tags) {
            charge.removeFromTags(old_tag)
        }
        
        // 新しいTagを登録
        for str_tag in str_tags {
            
            fetchRequestTag.predicate = NSPredicate(format: "name == %@", str_tag as CVarArg)
            let result = try? context.fetch(fetchRequestTag)
            
            if result!.count > 0 {
                charge.addToTags(result![0])
            } else {
                let newTag = Tag(context: context)
                newTag.id = UUID()
                newTag.createdAt = Date()
                newTag.name = str_tag
                charge.addToTags(newTag)
                
            }
            
        }
        
        // 古いcapと縁を切るための作業
//        switch (charge.from_pred, charge.from_next) {
//        case (let old_pred, let old_next) where old_pred == nil && old_next == nil:
//            break
//        case (let old_pred, let old_next?) where old_pred == nil:
//            old_next.from_pred = nil
//            if old_next.from_id == from {
//                old_next.from_balance += old_amount
//            } else {
//                old_next.to_balance -= old_amount
//            }
//            updateBalances(charge: old_next, from: old_from, to: old_to)
//
//        case (let old_pred?, let old_next) where old_next == nil:
//            old_pred.from_next = nil
//        case (let old_pred?, let old_next?):
//            old_pred.from_next = old_next
//            old_next.from_pred = old_pred
//
//            if old_next.from_id == from {
//                old_next.from_balance += old_amount
//            } else {
//                old_next.to_balance -= old_amount
//            }
//            updateBalances(charge: old_next, from: old_from, to: old_to)
//        default:
//            break
//        }
//
//        switch (charge.to_pred, charge.to_next) {
//        case (let old_pred, let old_next) where old_pred == nil && old_next == nil:
//            break
//        case (let old_pred, let old_next?) where old_pred == nil:
//            old_next.to_pred = nil
//            if old_next.to_id == to {
//                old_next.to_balance -= old_amount
//            } else {
//                old_next.from_balance += old_amount
//            }
//            updateBalances(charge: old_next, from: old_from, to: old_to)
//
//        case (let old_pred?, let old_next) where old_next == nil:
//            old_pred.to_next = nil
//        case (let old_pred?, let old_next?):
//            old_pred.to_next = old_next
//            old_next.to_pred = old_pred
//
//            if old_next.to_id == to {
//                old_next.to_balance += old_amount
//            } else {
//                old_next.from_balance -= old_amount
//            }
//            updateBalances(charge: old_next, from: old_from, to: old_to)
//        default:
//            break
//        }
//
//
////         predとnextを更新
//        if let from_pred = predCharge(targetCharge: charge, capId: from, context: context){
//            charge.from_pred = from_pred
//            if from_pred.from_id == from {
//                from_pred.from_next = charge
//            } else {
//                from_pred.to_next = charge
//            }
//        }
//
//        if let from_next = nextCharge(targetCharge: charge, capId: from, context: context){
//            charge.from_next = from_next
//            if from_next.from_id == from {
//                from_next.from_pred = charge
//            } else {
//                from_next.to_pred = charge
//            }
//        }
//
//        if let to_pred = predCharge(targetCharge: charge, capId: to, context: context){
//            charge.to_pred = to_pred
//            if to_pred.to_id == to {
//                to_pred.to_next = charge
//            } else {
//                to_pred.from_next = charge
//            }
//        }
//        if let to_next = nextCharge(targetCharge: charge, capId: to, context: context){
//            charge.to_next = to_next
//            if to_next.to_id == to {
//                to_next.to_pred = charge
//            } else {
//                to_next.from_pred = charge
//            }
//        }
//


        // chargeに結びついてるbalanceをpredから計算
//        if charge.status != Status.pending.rawValue || charge.included {
//            if let from_pred = charge.from_pred {
//                charge.from_balance = (from_pred.from_id == from) ? (from_pred.from_balance) - amount : (from_pred.to_balance) - amount
//            } else {
//                charge.from_balance = -amount
//            }
//
//            if let to_pred = charge.to_pred {
//                charge.to_balance = (to_pred.to_id == to) ? (to_pred.to_balance) + amount : (to_pred.from_balance) + amount
//            } else {
//                charge.to_balance = amount
//            }
//        } else { // if pending
//            if let from_pred = charge.from_pred {
//                charge.from_balance = (from_pred.from_id == from) ? (from_pred.from_balance)  : (from_pred.to_balance)
//            } else {
//                charge.from_balance = 0
//            }
//
//            if let to_pred = charge.to_pred {
//                charge.to_balance = (to_pred.to_id == to) ? (to_pred.to_balance): (to_pred.from_balance)
//            } else {
//                charge.to_balance = 0
//            }
//        }
////
////        // balanceの変化を未来へ伝播
//        updateBalances(charge: charge, from: from, to: to)
        
        
        
        let fetchRequestCapacitor : NSFetchRequest<Capacitor>
        fetchRequestCapacitor = Capacitor.fetchRequest()
        
        
        // fromのリレーション設定
        
        // 古いCapacitorとの縁を切る
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", old_from as CVarArg)
        
        let old_from_cap = try? context.fetch(fetchRequestCapacitor)
        
        if old_from_cap!.count > 0 {
            old_from_cap![0].removeFromOut_charges(charge)
            
            if old_status == Status.confirmed.rawValue {
                old_from_cap![0].balance += old_amount
            }
            
        }
        
        // 新しく設定されたCapacitorとの関係を作る
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", from as CVarArg)
        let result1 = try? context.fetch(fetchRequestCapacitor)
        if result1!.count > 0 {
            /// Charge -> Capacitorへのリレーション
            charge.from = result1![0]
            result1![0].addToOut_charges(charge)
            
            if status == Status.confirmed.rawValue { // Confirmed -> Confirmed
                result1![0].balance -= charge.amount
            }
            
            
        }
        
        
        
        // to リレーションの設定
        
        
        // 古いCapacitorとの縁を切る
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", old_to as CVarArg)
        
        let old_to_cap = try? context.fetch(fetchRequestCapacitor)
        
        if old_to_cap!.count > 0 {
            old_to_cap![0].removeFromIn_charges(charge)
            
            if old_status == Status.confirmed.rawValue {
                old_to_cap![0].balance -= old_amount
            }
            
        }
        
        // 新しく設定されたCapacitorとの関係を作る
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", to as CVarArg)
        let result2 = try? context.fetch(fetchRequestCapacitor)
        if result2!.count > 0 {
            /// Charge -> Capacitorへのリレーション
            charge.to = result2![0]
            result2![0].addToIn_charges(charge)
            
            if status == Status.confirmed.rawValue { // Confirmed -> Confirmed
                result2![0].balance += charge.amount
            }
            
            
        }
        
        
        
        
        // 通知の設定
        
        
        if old_status == Status.confirmed.rawValue{
            if status == Status.confirmed.rawValue {
                // Nothing to do
                
            } else{
                let uuid = makeNotification(title: name + " ¥ \(amount)" , body: note, date: date)
                charge.notification_id = uuid
                
            }
        } else {
            let center = UNUserNotificationCenter.current()
            if charge.notification_id != nil {
                center.removePendingNotificationRequests(withIdentifiers: [charge.notification_id!.uuidString])
            }
            
            
            if status == Status.confirmed.rawValue {
                // Nothing to do
                
            } else{
                let uuid = makeNotification(title: name + " ¥ \(amount)" , body: note, date: date)
                charge.notification_id = uuid
            }
        }
        
        
        updateVariableCharge(context: context)
        
        save(context: context)
        
        updateChargeBalances(capId: from, context: context)
        updateChargeBalances(capId: to, context: context)
        
        save(context: context)
        
    }
    
    func deleteCharge(charge: Charge, context: NSManagedObjectContext){
        
        switch (charge.from_pred, charge.from_next) {
            case (let pred, let next) where pred == nil && next == nil:
                break
            case (let pred, let next?) where pred == nil:
                next.from_pred = nil
                
                updateBalances(charge: next, from: charge.from_id!, to: charge.to_id!)
                
            case (let pred?, let next) where next == nil:
                pred.from_next = nil
            case (let pred?, let next?):
                pred.from_next = next
                next.from_pred = pred
            
                updateBalances(charge: next, from: charge.from_id!, to: charge.to_id!)
            default:
                break
        }
        
        switch (charge.to_pred, charge.to_next) {
            case (let pred, let next) where pred == nil && next == nil:
                break
            case (let pred, let next?) where pred == nil:
                next.to_pred = nil
                updateBalances(charge: next, from: charge.from_id!, to: charge.to_id!)
                
            case (let pred?, let next) where next == nil:
                pred.to_next = nil
            case (let pred?, let next?):
                pred.to_next = next
                next.to_pred = pred
                updateBalances(charge: next, from: charge.from_id!, to: charge.to_id!)
            default:
                break
        }
        
        if charge.status == Status.confirmed.rawValue {
            if let from = charge.from, let to = charge.to {
                from.balance += charge.amount
                to.balance -= charge.amount
            }
            
        }
        
        save(context: context)
    }
    
    func calcAmount(start: Date, end: Date, from: UUID, to: UUID, context: NSManagedObjectContext) -> Int {
        
        let fetchRequestCharge : NSFetchRequest<Charge>
        fetchRequestCharge = Charge.fetchRequest()
        
        fetchRequestCharge.predicate = NSPredicate(format: "from_id == %@ && to_id == %@ && date >= %@ && date <= %@", from as CVarArg, to as CVarArg, start as CVarArg, end as CVarArg)
        var sum = 0
        
        let charges = try? context.fetch(fetchRequestCharge)
        
        if charges!.count > 0 {
            for charge in charges!{
                sum += Int(charge.amount)
            }
        }
        
        return sum
    }
    
    // Currentによって生まれたChargeの中ですでにConfirmedになったもの以外のChargeを消す
    func deleteRelevantCharges(current: Current, context: NSManagedObjectContext){
        let charges = chargeArray(current.charges)
        
        for charge in charges{
            if charge.status != Status.confirmed.rawValue {
                context.delete(charge)
            }
        }
        
        
        save(context: context)
        
        updateBalance(capacitor: current.from!, context: context)
        updateBalance(capacitor: current.to!, context: context)
        
    }
    
    func addCapacitor(name:String, init_balance: Int32, context: NSManagedObjectContext){
        let capacitor = Capacitor(context: context)
        capacitor.id = UUID()
        capacitor.createdAt = Date()
        capacitor.name = name
        capacitor.balance = init_balance
        capacitor.init_balance = init_balance
        
        save(context: context)
    }
    
    func editCapacitor(capacitor: Capacitor, name:String, init_balance: Int32, context: NSManagedObjectContext){
        
        capacitor.name = name
        capacitor.init_balance = init_balance
        
        updateBalance(capacitor: capacitor, context: context)
        
        save(context: context)
    }
    
    func updateBalance(capacitor: Capacitor, context: NSManagedObjectContext){
        
        let in_charges = capacitor.in_charges
        let out_charges = capacitor.out_charges
        
        var balance = capacitor.init_balance
        
        for in_charge in chargeArray(in_charges){
            balance += in_charge.amount
        }
        
        for out_charge in chargeArray(out_charges){
            balance -= out_charge.amount
        }
        
        capacitor.balance = balance
        
        save(context: context)
        
        
    }
    
//    func hasSomeCurrents(capacitor: Capacitor, context: NSManagedObjectContext){
//
//    }
    
    func addCurrent(name: String, amount: Int32, from: UUID, to:UUID, every: Int16, span: String, day: Int16, month:Int16, weekday: Int16, next: Date, category: UUID, context: NSManagedObjectContext) {
        
      
        
        let current = Current(context: context)
        current.id = UUID()
        current.createdAt = Date()
        current.name = name
        current.amount = amount
        current.from_id = from
        current.to_id = to
        current.every = every
        current.span = span
        current.day = day
        current.month = month
        current.weekday = weekday
        current.next = next
        
        
        
        let fetchRequestCategory: NSFetchRequest<Category>
        fetchRequestCategory = Category.fetchRequest()
        
        fetchRequestCategory.predicate = NSPredicate(format: "id == %@", category as CVarArg)
        let result = try? context.fetch(fetchRequestCategory)
        
        if result!.count > 0 {
            current.category = result![0]
        }
        
        
        
        let fetchRequestCapacitor : NSFetchRequest<Capacitor>
        fetchRequestCapacitor = Capacitor.fetchRequest()
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@",from as CVarArg)
        
        let result1 = try? context.fetch(fetchRequestCapacitor)

        if result1!.count > 0 {
            /// Current -> Capacitorへのリレーション
            
            current.from = result1![0]
            result1![0].addToOut_currents(current)
            
           
        }
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", to as CVarArg)
        let result2 = try? context.fetch(fetchRequestCapacitor)

        if result2!.count > 0 {
            /// Current -> Capacitorへのリレーション
            current.to = result2![0]
            result2![0].addToIn_currents(current)
           
        }
        
        generateCharge(current: current, context: context)
        
        save(context: context)
    
        
    }
    
    func editCurrent(current: Current, name: String, amount: Int32, from: UUID, to: UUID, every: Int16, span: String, day: Int16, month: Int16, weekday: Int16, next: Date, category: UUID, context: NSManagedObjectContext){
        
       
        
        
        let fetchRequestCategory: NSFetchRequest<Category>
        fetchRequestCategory = Category.fetchRequest()
        
        fetchRequestCategory.predicate = NSPredicate(format: "id == %@", category as CVarArg)
        let result = try? context.fetch(fetchRequestCategory)
        
        if result!.count > 0 {
            current.category = result![0]
        }
        
        
        let fetchRequestCapacitor : NSFetchRequest<Capacitor>
        fetchRequestCapacitor = Capacitor.fetchRequest()
        
       
        // もともとあったrelationの削除
        if let old_from = current.from_id {
            fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@",old_from as CVarArg)
            let result1 = try? context.fetch(fetchRequestCapacitor)
            
            if result1!.count > 0 {
                result1![0].removeFromOut_currents(current)
            }
        }
        
        if let old_to = current.to_id {
            fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@",old_to as CVarArg)
            let result2 = try? context.fetch(fetchRequestCapacitor)
            
            if result2!.count > 0 {
                result2![0].removeFromIn_currents(current)
            }
            
        }
        
        current.name = name
        current.amount = amount
        current.from_id = from
        current.to_id = to
        current.every = every
        current.span = span
        current.day = day
        current.month = month
        current.weekday = weekday
        current.next = next
        
        
        
        
       
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@",from as CVarArg)
        
        let result3 = try? context.fetch(fetchRequestCapacitor)

        if result3!.count > 0 {
            /// Current -> Capacitorへのリレーション
            
            current.from = result3![0]
            result3![0].addToOut_currents(current)
           
           
        }
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", to as CVarArg)
        let result4 = try? context.fetch(fetchRequestCapacitor)

        if result4!.count > 0 {
            /// Current -> Capacitorへのリレーション
            current.to = result4![0]
            result4![0].addToIn_currents(current)
           
        }
        
        
        generateCharge(current: current, context: context)
        save(context: context)
        
        
        
    }
    
    func nearestUpcomingPayment(current: Current, context: NSManagedObjectContext) -> Date? {
        
        for charge in chargeArray(current.charges) {
            if charge.status == Status.upcoming.rawValue {
                return charge.date
            }
        }
        
        return nil
        
        
    }
    func generateCharge(current: Current, context: NSManagedObjectContext){
        if let next = current.next, let from_id = current.from_id, let to_id = current.to_id, let category = current.category {
            let newCharge = addCharge(name: current.name ?? "", amount: current.amount, date: next, status: Int16(Status.upcoming.rawValue), from: from_id, to: to_id, note: "", included: false, is_variable: false, start: Date(), end: Date(), vfrom_id: gndId!, vto_id: gndId!, category: category.id!, context: context)
            
            
            current.addToCharges(newCharge)
            
            updateNext(current: current, context: context)
        }
        
    }
    
    func generateNextCharges(capId: UUID, context: NSManagedObjectContext){
        
        let fetchRequestCurrent : NSFetchRequest<Current>
        fetchRequestCurrent = Current.fetchRequest()
        
        fetchRequestCurrent.predicate = NSPredicate(format: "from_id == %@ || to_id == %@", capId as CVarArg, capId as CVarArg)
        
        fetchRequestCurrent.sortDescriptors = [NSSortDescriptor(key: "next", ascending: true)]
        
        
        let currents = try? context.fetch(fetchRequestCurrent)
        
     
        
        if currents!.count > 0 {
            
        
            for current in currents!{
                
                
                if let latestCharge = getLatestCharge(context: context), let next = current.next {
                    guard let latestDate = latestCharge.date else { print("no date in latestCharge"); return }
                    if latestDate >= next {
                        generateCharge(current: current, context: context)
                    } else {
                        if isSameMonth(date1: latestDate, date2: next) {
                            generateCharge(current: current, context: context)
                        } else {
                            generateCharge(current: current, context: context)
                            break
                        }
                        
                    }
                    
                } else {
                    generateCharge(current: current, context: context)
                }
                
                
            }
        
        }
        
    }
    
    
    func updateNext(current: Current, context: NSManagedObjectContext) {
        
        let calendar = Calendar.current
        
        if let next = current.next {
            if current.span == "day" {
                current.next = calendar.date(byAdding: .day, value: Int(current.every), to: next)!
            } else if current.span == "week" {
                let weekday = Calendar.current.component(.weekday, from: next) - 1
                current.next = Calendar.current.date(byAdding: .day, value: (Int(current.weekday) - weekday) + Int(current.every) * 7, to: next)!
                
            } else if current.span == "month" {
                
                let newNext = Calendar.current.date(byAdding: .month, value: Int(current.every), to: next)!
                
                if current.day == 0 || current.day == 31 {
                    current.next = lastDayOfMonth(for: newNext)
                } else {
                    
                    var newDateComponents = calendar.dateComponents([.year, .month], from: newNext)
                    newDateComponents.day = Int(current.day)

                    current.next = calendar.date(from: newDateComponents)
                }
                
               
                
            } else if current.span == "year" {
                var newNext = Calendar.current.date(byAdding: .year, value: Int(current.every), to: next)!
                newNext = Calendar.current.date(bySetting: .month, value: Int(current.month), of: newNext)!
                
                if current.day == 0 || current.day == 31{
                    current.next = lastDayOfMonth(for: newNext)
                } else {
                    var newDateComponents = calendar.dateComponents([.year, .month], from: newNext)
                    newDateComponents.day = Int(current.day)

                    current.next = calendar.date(from: newDateComponents)
                }
                
            }
        }
        save(context: context)
    }
    
    func isSameMonthOrOlder(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let month1 = calendar.component(.month, from: date1)
        let month2 = calendar.component(.month, from: date2)
        if month1 == month2 {
            return true
        }
        return date2 < date1
    }
    
    func isSameMonth(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let month1 = calendar.component(.month, from: date1)
        let month2 = calendar.component(.month, from: date2)
        return month1 == month2
            
    }
    func getLatestCharge(context: NSManagedObjectContext) -> Charge? {
        let fetchRequestCharge : NSFetchRequest<Charge>
        fetchRequestCharge = Charge.fetchRequest()
        
        fetchRequestCharge.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let result = try? context.fetch(fetchRequestCharge)
        
        if result!.count > 0 {
            return result![0]
        } else {
            return nil
        }
    }
    
    func addTag(name: String, context: NSManagedObjectContext){
        let tag = Tag(context: context)
        tag.id = UUID()
        
        tag.createdAt = Date()
        tag.name = name
        
        
        
        
        save(context: context)
    }
    
    func addCategory(name: String, context: NSManagedObjectContext) -> Category {
        
        
        let category = Category(context: context)
        category.id = UUID()
        
        category.createdAt = Date()
        category.name = name
        
        save(context: context)
        
        return category
        
        
    }
    
    
    // Uncategorizedというカテゴリは必ずあると仮定している
    func fetchUncategorized(context: NSManagedObjectContext) -> Category {

        let fetchRequestCategory : NSFetchRequest<Category>
        fetchRequestCategory = Category.fetchRequest()

        fetchRequestCategory.predicate = NSPredicate(format: "name == 'Uncategorized'")

        let result = try? context.fetch(fetchRequestCategory)

        return result![0]

    }
    // Capacitor内で、CurrentにとってのNextのdateが変更されたら、それをCurrentのnextToPayに反映
//    func updateNextToPay(current: Current, context:NSManagedObjectContext ){
//
//
//        let nearest = nearestUpcomingPayment(current: current)
////        current.nextToPay = nearest
//
//        save(context: context)
//    }
    
    // 毎秒実行
    // 来月の末日までにCurrentのnextToConductが入っていたら、Currentの内容をChargeとして実体化する
//    func applyCurrents(context: NSManagedObjectContext){
//
//        let fetchRequestCurrent : NSFetchRequest<Current>
//        fetchRequestCurrent = Current.fetchRequest()
//
//        let today = Date()
//
//        let this_month = Calendar.current.component(.month, from: today)
//
//
//        var component = NSCalendar.current.dateComponents([.year], from: today)
//        component.month = this_month + 2
//        component.day = 1
//        component.hour = 0
//        component.minute = 0
//        component.second = 0
//
//        let the_end_of_the_next_month:NSDate = NSCalendar.current.date(from:component)! as NSDate
//
//
//
//
//
//
////        fetchRequestCurrent.predicate = NSPredicate(format: "nextToConduct <= %@",the_end_of_the_next_month as CVarArg)
//        let results = try? context.fetch(fetchRequestCurrent)
//
//
//        if results!.count > 0 {
//
//            print("Found a current!!")
//            for current in results! {
//                let newCharge = Charge(context:context)
//                newCharge.id = UUID()
//                newCharge.createdAt = Date()
//                newCharge.amount = current.amount
////                newCharge.date = current.nextToConduct
//                newCharge.name = current.name
//                newCharge.status = Int16(Status.upcoming.rawValue)
//                newCharge.from_id = current.from_id
//                newCharge.to_id = current.to_id
//
//                let fetchRequestCapacitor : NSFetchRequest<Capacitor>
//                fetchRequestCapacitor = Capacitor.fetchRequest()
//
//
//                fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", current.from_id! as CVarArg)
//                let result1 = try? context.fetch(fetchRequestCapacitor)
//                if result1!.count > 0 {
//                    /// Charge -> Capacitorへのリレーション
//
//                    newCharge.from = result1![0]
//                    result1![0].addToOut_charges(newCharge)
//
//                }
//
//                /// to リレーションの設定
//                fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", current.to_id! as CVarArg)
//                let result2 = try? context.fetch(fetchRequestCapacitor)
//                if result2!.count > 0 {
//                    /// Charge -> Capacitorへのリレーション
//
//                    newCharge.to = result2![0]
//                    result2![0].addToIn_charges(newCharge)
//
//                }
//
//                // Charge と Currentのリレーションの設定
//                newCharge.current = current
//                current.addToCharges(newCharge)
////                print("every: \(current.every)")
////                print("span: \(current.span!)")
////                print("day: \(current.day)")
////                print("month: \(current.month)")
////                print("weekday: \(current.weekday)")
//
////                current.nextToConduct = calcNext(previous: current.nextToConduct!, every: Int(current.every), span: current.span!, on_day: Int(current.day), on_month: Int(current.month), on_weekday: Int(current.weekday))
////
////                print(current.next!)
//
//
//            }
//        }
//
//
//
//
//    }
//
//
//
    //そのCapacitorのstartからendまでのChargeの合計金額を返す
//    private func total_charges(start: Date, end: Date, capacitor: Capacitor, context: NSManagedObjectContext) -> Int32 {
//        var sum: Int32 = 0
//        
//        var component1 = NSCalendar.current.dateComponents([.year,.month,.day], from: start)
//        
//        component1.hour = 0
//        component1.minute = 0
//        component1.second = 0
//        
//        let start:NSDate = NSCalendar.current.date(from:component1)! as NSDate
//        
//        var component2 = NSCalendar.current.dateComponents([.year,.month,.day], from: end)
//        
//        component2.day = component2.day! + 1
//        component2.hour = 0
//        component2.minute = 0
//        component2.second = 0
//        
//        let fetchRequestCharge : NSFetchRequest<Charge>
//        fetchRequestCharge = Charge.fetchRequest()
//        
//        fetchRequestCharge.predicate = NSPredicate(format: "date >= %@ && date < %@ && from_id = %@", start as CVarArg, end as CVarArg, capacitor.id! as CVarArg)
//        
//        let out_charges = try? context.fetch(fetchRequestCharge)
//        
//        
//        
////        for out_charge in out_charges! {
////            if out_charge.to!.id! == outside_id {
////                if out_charge.status != Status.pending.rawValue {
////                    sum -= out_charge.amount
////                }
////
////            }
////        }
//        
//        fetchRequestCharge.predicate = NSPredicate(format: "date >= %@ && date < %@ && to_id = %@", start as CVarArg, end as CVarArg, capacitor.id! as CVarArg)
//        
//        let in_charges = try? context.fetch(fetchRequestCharge)
//        
////        for in_charge in in_charges! {
////            if in_charge.from!.id! == outside_id {
////                if in_charge.status != Status.pending.rawValue {
////                    sum += in_charge.amount
////                }
////            }
////        }
//        
//        return sum
//        
//        
//    
//        
//        
//    }
    
    
    
    
    func togglePending(charge: Charge, context: NSManagedObjectContext){
        
        editCharge(charge: charge, name: charge.name ?? "", amount: charge.amount, date: charge.date ?? Date(), status: charge.status, from: charge.from_id ?? gndId!, to: charge.to_id ?? gndId!, note: charge.note ?? "", included: !charge.included, is_variable: charge.is_variable, start: charge.start ?? Date(), end : charge.end ?? Date(), vfrom_id: charge.vfrom_id!, vto_id: charge.vto_id!, category: charge.category?.id ?? uncatId!, context: context)
        
        
    }
    
    func toggleUpcoming(charge: Charge, context: NSManagedObjectContext){
        
        if charge.status == Status.upcoming.rawValue {
            editCharge(charge: charge, name: charge.name ?? "", amount: charge.amount, date: charge.date ?? Date(), status: Int16(Status.confirmed.rawValue), from: charge.from_id ?? gndId!, to: charge.to_id ?? gndId!, note: charge.note ?? "", included: charge.included, is_variable: charge.is_variable, start: charge.start ?? Date(), end : charge.end ?? Date(), vfrom_id: charge.vfrom_id!, vto_id: charge.vto_id!,category: charge.category?.id ?? uncatId!,  context: context)
        } else if charge.status == Status.confirmed.rawValue {
            editCharge(charge: charge, name: charge.name ?? "", amount: charge.amount, date: charge.date ?? Date(), status: Int16(Status.upcoming.rawValue), from: charge.from_id ?? gndId!, to: charge.to_id ?? gndId!, note: charge.note ?? "", included: charge.included, is_variable: charge.is_variable, start: charge.start ?? Date(), end : charge.end ?? Date(), vfrom_id: charge.vfrom_id!, vto_id: charge.vto_id!, category: charge.category?.id ?? uncatId!,  context: context)
        }
      
    
        
    }
    
    func fetchCapBalance(capId: UUID, context: NSManagedObjectContext) -> Int {
        
        let fetchRequestCapacitor : NSFetchRequest<Capacitor>
        fetchRequestCapacitor = Capacitor.fetchRequest()

        var balance: Int32 = 0
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", capId as CVarArg)
        let result1 = try? context.fetch(fetchRequestCapacitor)
        if result1!.count > 0 {
            balance = result1![0].balance
        }
        
        return Int(balance)
        
        
    }
    
    func fetchCapInitBalance(capId: UUID, context: NSManagedObjectContext) -> Int {
        
        let fetchRequestCapacitor : NSFetchRequest<Capacitor>
        fetchRequestCapacitor = Capacitor.fetchRequest()

        var initBalance: Int32 = 0
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", capId as CVarArg)
        let result1 = try? context.fetch(fetchRequestCapacitor)
        if result1!.count > 0 {
            initBalance = result1![0].init_balance
        }
        
        return Int(initBalance)
        
        
    }
    
    
    
    
    func getOneCapacitor(context:NSManagedObjectContext ) -> UUID? {
    
        let fetchRequestCapacitor : NSFetchRequest<Capacitor>
        fetchRequestCapacitor = Capacitor.fetchRequest()
    
    
        let items = try? context.fetch(fetchRequestCapacitor)
        
        if items!.count > 0{
            for item in items! {
                if item.name != "Source" && item.name != "Ground" {
                    return item.id
                }
            }
        }
    
    
        return nil
    }

}
