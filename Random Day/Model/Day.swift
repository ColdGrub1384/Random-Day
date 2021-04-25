//
//  Day.swift
//  Random Day
//
//  Created by Emma Labbé on 23-04-21.
//

import Foundation

struct Day: Codable {
    
    var date: Date
    
    var tasks: [Task]
    
    init(date: Date, tasks: [Task]) {
        self.date = Calendar.current.startOfDay(for: date)
        self.tasks = tasks
    }
}

func makeDayIfNeeded() {
    if Calendar.current.startOfDay(for: CurrentDayManager.shared.today.date) != Calendar.current.startOfDay(for: Date()), let weekday = Weekday(date: Date()), let today = DatabaseManager.shared.database.plannedDays[weekday]?.makeDay(for: Date()) {
        CurrentDayManager.shared.today = today
    }
}

let previewDay = Day(date: Date(), tasks: [
    Task(name: "Tomar desayuno", duration: 60*30, startTime: 60*60*8),
    Task(name: "Jugar Minecraft", duration: 60*60, startTime: 60*60*9),
    Task(name: "Jugar Pokemon", duration: 60*60*2, startTime: 60*60*11),
    Task(name: "Almorzar", duration: 60*60, startTime: 60*60*13),
    Task(name: "Programar", duration: 60*60*5, startTime: 60*60*14),
    Task(name: "Programar", duration: 60*60*1, startTime: 60*60*23+60*5)
])
