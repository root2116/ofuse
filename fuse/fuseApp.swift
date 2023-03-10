//
//  FuseApp.swift
//  Fuse
//
//  Created by araragi943 on 2022/06/09.
//

import SwiftUI

@main
struct FuseApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,dataController.container.viewContext)
                
        }
    }
}
