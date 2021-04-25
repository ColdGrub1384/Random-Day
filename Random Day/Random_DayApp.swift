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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.onChange(of: scenePhase) { newScenePhase in
            makeDayIfNeeded()
        }
    }
}
