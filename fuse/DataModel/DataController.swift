//
//  DataController.swift
//  fuse
//
//  Created by araragi943 on 2022/06/09.
//

import Foundation
import CoreData




func registSampleData(context: NSManagedObjectContext) {
    
    print("Register!!")
    
    let outside_id = "CE130F1C-3B2F-42CA-8339-1549531E0102"
    let bank_id = UUID().uuidString
    let credit_id = UUID().uuidString
    
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
        [outside_id,"Outside", "0"],
        [bank_id,"Bank", "0"],
        [credit_id,"Credit Card", "0"]
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
    
    /// Capacitorテーブル登録
    for capacitor in capacitorList {
        let newCapacitor = Capacitor(context: context)
        newCapacitor.id = UUID(uuidString: capacitor[0])
        newCapacitor.createdAt = Date()
        newCapacitor.name = capacitor[1]
        newCapacitor.balance = Int32(capacitor[2])!
        
    }
 
    
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd"
    
    /// Flowテーブル登録
    for flow in flowList {
        let newFlow = Flow(context: context)
        
        newFlow.id = UUID()
        newFlow.name = flow[2]
        newFlow.date = format.date(from: flow[5])
//        newFlow.from = UUID(uuidString: flow[0])
//        newFlow.to = UUID(uuidString: flow[1])
        newFlow.amount = Int32(flow[3])!
        newFlow.status = Int16(flow[4])!
 
        /// from リレーションの設定
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", UUID(uuidString: flow[0])! as CVarArg)
        
        let result1 = try? context.fetch(fetchRequestCapacitor) as? [Capacitor]
//        print(result1)
        if result1!.count > 0 {
            /// Flow -> Capacitorへのリレーション
            newFlow.from = result1![0]
            result1![0].addToOut_flows(newFlow)
            print("Set FROM relation!!")
        }
        
        /// to リレーションの設定
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", UUID(uuidString: flow[1])! as CVarArg)
        let result2 = try? context.fetch(fetchRequestCapacitor) as? [Capacitor]
        if result2!.count > 0 {
            /// Flow -> Capacitorへのリレーション
            newFlow.to = result2![0]
            result2![0].addToIn_flows(newFlow)
            print("Set TO relation!!")
        }
    }
    
    /// コミット
    try? context.save()
}
 

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "FlowModel")
    
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
    
    func addFlow(name: String, amount: Int32, date: Date, status: Int16, from: UUID, to: UUID, context: NSManagedObjectContext){
        let newFlow = Flow(context:context)
        newFlow.id = UUID()
        newFlow.createdAt = Date()
        newFlow.amount = amount
        newFlow.date = date
        newFlow.name = name
        newFlow.status = status
        
        let fetchRequestCapacitor : NSFetchRequest<Capacitor>
        fetchRequestCapacitor = Capacitor.fetchRequest()

        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", from as CVarArg)
        let result1 = try? context.fetch(fetchRequestCapacitor)
        if result1!.count > 0 {
            /// Flow -> Capacitorへのリレーション
            print("Set FROM relation!!")
            newFlow.from = result1![0]
            result1![0].addToOut_flows(newFlow)
        }
        
        /// to リレーションの設定
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", to as CVarArg)
        let result2 = try? context.fetch(fetchRequestCapacitor)
        if result2!.count > 0 {
            /// Flow -> Capacitorへのリレーション
            print("Set TO relation!!")
            newFlow.to = result2![0]
            result2![0].addToIn_flows(newFlow)
        }
        
        
        save(context: context)
        
        
    }
    
    func editFlow(flow: Flow, name: String, amount: Int32, date: Date,status:Int16,from: UUID, to:UUID, context: NSManagedObjectContext){
        flow.date = date
        flow.name = name
        flow.amount = amount
        
        flow.status = status
        
        
        let fetchRequestCapacitor : NSFetchRequest<Capacitor>
        fetchRequestCapacitor = Capacitor.fetchRequest()
        
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", from as CVarArg)
        let result1 = try? context.fetch(fetchRequestCapacitor)
        if result1!.count > 0 {
            /// Flow -> Capacitorへのリレーション
            flow.from = result1![0]
            result1![0].addToOut_flows(flow)
        }
        
        /// to リレーションの設定
        fetchRequestCapacitor.predicate = NSPredicate(format: "id == %@", to as CVarArg)
        let result2 = try? context.fetch(fetchRequestCapacitor)
        if result2!.count > 0 {
            /// Flow -> Capacitorへのリレーション
            flow.to = result2![0]
            result2![0].addToIn_flows(flow)
        }
        
        
        
        
        save(context: context)
    }
    
    func addCapacitor(name:String, init_balance: Int32, context: NSManagedObjectContext){
        let capacitor = Capacitor(context: context)
        capacitor.id = UUID()
        capacitor.createdAt = Date()
        capacitor.name = name
        capacitor.balance = init_balance
        
        save(context: context)
    }
    
    
    
}
