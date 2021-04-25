//
//  CurrentDayManager.swift
//  Random Day
//
//  Created by Emma Labbé on 23-04-21.
//

import SwiftUI
import Combine

class CurrentDayManager: ObservableObject, Hashable {
    
    static func == (lhs: CurrentDayManager, rhs: CurrentDayManager) -> Bool {
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }
    
    static let shared = CurrentDayManager()
    
    private var updateTimer: Timer?
    
    private var previousStates = [Task.State]()
    
    func startUpdateTimer() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            var states = [Task.State]()
            for item in self.today.tasks {
                states.append(item.state(for: self.today))
            }
            
            if self.previousStates != states {
                self.objectWillChange.send()
                self.previousStates = states
            }
        })
    }
    
    func stopUpdateTimer() {
        updateTimer?.invalidate()
    }
    
    private init() {}
    
    var today: Day {
        get {
            return DatabaseManager.shared.database.today ?? Day(date: .distantPast, tasks: [])
        }
        
        set {
            if newValue.tasks.count == 0 {
                DatabaseManager.shared.database.today = Day(date: .distantPast, tasks: [])
            } else {
                DatabaseManager.shared.database.today = newValue
            }
            objectWillChange.send()
        }
    }
    
    var weekday: String? {
        let formatter = DateFormatter()
        return formatter.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
    }
}
