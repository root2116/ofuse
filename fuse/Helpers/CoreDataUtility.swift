//
//  CoreDataUtility.swift
//  fuse
//
//  Created by araragi943 on 2022/08/14.
//

import Foundation
import SwiftUI


func getName(items: FetchedResults<Capacitor>, id: UUID) -> String {
    for item in items {
        if item.id == id {
            return item.name!
        }
    }
    
    return ""
}
