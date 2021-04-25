//
//  PlannedDay.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import Foundation

struct PlannedDay: Codable, Equatable {
    
    var weekday: Weekday
    
    private var _tasks: [FutureTask]
    
    var tasks: [FutureTask] {
        get {
            return _tasks
        }
        
        set {
            _tasks = newValue.sorted(by: { $0.endTime < $1.endTime })
        }
    }
    
    init(weekday: Weekday, tasks: [FutureTask]) {
        self.weekday = weekday
        self._tasks = tasks.sorted(by: { $0.endTime < $1.endTime })
    }
    
    func makeDay(for date: Date) -> Day {
        
        var tasks = [Task]()
        
        for task in self.tasks {
            if var constant = task.staticTask {
                constant.startTime = task.startTime
                tasks.append(constant)
            } else if let categories = task.categories {
                var allTasks = [Task]()
                
                for categoryName in categories {
                    guard let category = DatabaseManager.shared.database.category(with: categoryName) else {
                        continue
                    }
                    
                    for _task in category.tasks {
                        var newTask = _task
                        newTask.startTime = task.startTime
                        allTasks.append(newTask)
                    }
                }
                
                if let random = allTasks.randomElement() {
                    tasks.append(random)
                }
            }
        }
        
        return Day(date: Calendar.current.startOfDay(for: date), tasks: tasks)
    }
}
