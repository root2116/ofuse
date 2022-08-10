//
//  DataController.swift
//  fuse
//
//  Created by araragi943 on 2022/06/09.
//

import Foundation
import CoreData

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
    
    func addFlow(name: String, amount: Int32, date: Date, context: NSManagedObjectContext){
        let flow = Flow(context:context)
        flow.id = UUID()
        flow.createdAt = Date()
        flow.amount = amount
        flow.date = date
        flow.name = name
//        flow.capacitor_id = capacitor_id
//        flow.status = status
        
        save(context: context)
        
    }
    
    func editFlow(flow: Flow, name: String, amount: Int32, date: Date, context: NSManagedObjectContext){
        flow.date = date
        flow.name = name
        flow.amount = amount
//        flow.capacitor_id = capacitor_id
//        flow.status = status
        
        save(context: context)
    }
}
