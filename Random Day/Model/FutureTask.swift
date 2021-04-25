//
//  FutureTask.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import Foundation

struct FutureTask: Codable, Equatable {
    
    static func == (lhs: FutureTask, rhs: FutureTask) -> Bool {
        return lhs.categories == rhs.categories && lhs.staticTask == rhs.staticTask && lhs.startTime == rhs.startTime
    }
    
    var categories: [String]?
    
    var staticTask: Task?
    
    var startTime: TimeInterval
    
    var endTime: TimeInterval {
        
        if let task = staticTask {
            return (task.startTime ?? 0)+task.duration
        }
        
        var durations = [TimeInterval]()
        for categoryName in categories ?? [] {
            guard let category = DatabaseManager.shared.database.category(with: categoryName) else {
                continue
            }
            
            for task in category.tasks {
                durations.append(task.duration)
            }
        }
        
        return startTime+(durations.max() ?? 0)
    }
    
    init(categories: [String], startTime: TimeInterval) {
        self.categories = categories
        self.startTime = startTime
    }
    
    init(staticTask: Task, startTime: TimeInterval) {
        var task = staticTask
        task.startTime = startTime
        self.staticTask = task
        self.startTime = startTime
    }
    
    func formattedEndTime(for day: Day) -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        if let task = staticTask {
            let date = day.date.addingTimeInterval(startTime+task.duration)
            return formatter.string(from: date)
        }
        
        guard let categories = categories else {
            return ""
        }
        
        var durations = [TimeInterval]()
        for categoryName in categories {
            guard let category = DatabaseManager.shared.database.category(with: categoryName) else {
                continue
            }
            
            for task in category.tasks {
                durations.append(task.duration)
            }
        }
        
        let max = durations.max() ?? 0
        let date = day.date.addingTimeInterval(startTime+max)
        return formatter.string(from: date)
    }
    
    func formattedStartTime(for day: Day) -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        return formatter.string(from: day.date.addingTimeInterval(startTime))
    }
    
    var id: UUID {
        return UUID()
    }
}
