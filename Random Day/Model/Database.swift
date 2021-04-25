//
//  Database.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import Foundation

struct Database: Codable, Equatable {
    
    static func == (lhs: Database, rhs: Database) -> Bool {
        return lhs.taskCategories == rhs.taskCategories && lhs.plannedDays == rhs.plannedDays && lhs.today == rhs.today
    }
    
    var taskCategories: [TaskCategory]
    
    func category(with name: String) -> TaskCategory? {
        for category in taskCategories {
            if category.name == name {
                return category
            }
        }
        
        return nil
    }
    
    var plannedDays: [Weekday : PlannedDay]
    
    var today: Day?
}
