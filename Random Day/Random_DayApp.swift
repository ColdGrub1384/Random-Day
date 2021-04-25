//
//  Random_DayApp.swift
//  Random Day
//
//  Created by Emma Labbé on 23-04-21.
//

import SwiftUI

@main
struct Random_DayApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        Zephyr.sync(keys: "database", userDefaults: defaults ?? .standard)
        DatabaseManager.shared.database = Database.fromDisk()
        NotificationCenter.default.addObserver(forName: Zephyr.keysDidChangeOnCloudNotification, object: nil, queue: nil) { (_) in
            DatabaseManager.shared.database = Database.fromDisk()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.onChange(of: scenePhase) { newScenePhase in
            makeDayIfNeeded()
        }
    }
}
