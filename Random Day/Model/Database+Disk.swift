//
//  Database+Disk.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import Foundation

fileprivate let defaults = UserDefaults(suiteName: "group.randomday")

extension Database {
    
    static func fromDisk() -> Database {
        do {
            guard let databaseData = defaults?.data(forKey: "database") else {
                return Database(taskCategories: [], plannedDays: [:], today: nil)
            }
            
            return try JSONDecoder().decode(Database.self, from: databaseData)
        } catch {
            print(error.localizedDescription)
            return Database(taskCategories: [], plannedDays: [:], today: nil)
        }
    }
    
    func saveToDisk() {
        do {
            let data = try JSONEncoder().encode(self)
            defaults?.setValue(data, forKey: "database")
        } catch {
            print(error.localizedDescription)
        }
    }
}
