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
                .environment(\.outsideId, UUID(uuidString: "CE130F1C-3B2F-42CA-8339-1549531E0102")!)
        }
    }
}
