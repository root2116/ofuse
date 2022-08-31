//
//  CoreDataUtility.swift
//  fuse
//
//  Created by araragi943 on 2022/08/14.
//

import Foundation
import SwiftUI
import CoreData

func getName(items: FetchedResults<Capacitor>, id: UUID) -> String {
    
    
    for item in items {
        if item.id == id {
            
            return item.name!
        }
    }
    
    return items[0].name!
}


func get_a_bank_capacitor(context:NSManagedObjectContext ) -> UUID {
    
    let fetchRequestCapacitor : NSFetchRequest<Capacitor>
    fetchRequestCapacitor = Capacitor.fetchRequest()


    let items = try? context.fetch(fetchRequestCapacitor)
    
    if items!.count > 0{
        for item in items! {
            if item.type == CapType.bank.rawValue {
                return item.id!
            }
        }
    }
   
    
    return UUID(uuidString: "CE130F1C-3B2F-42CA-8339-1549531E0102")!
}
