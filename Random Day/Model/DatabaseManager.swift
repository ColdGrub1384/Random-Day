//
//  DatabaseManager.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import SwiftUI

class DatabaseManager: ObservableObject {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    @Published var database = Database.fromDisk() {
        didSet {
            if let weekday = Weekday(date: Date()), oldValue.plannedDays[weekday] != database.plannedDays[weekday] {
                database.today = database.plannedDays[weekday]?.makeDay(for: Date())
            }
            
            database.saveToDisk()
            objectWillChange.send()
        }
    }
}
