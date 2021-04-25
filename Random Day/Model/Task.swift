//
//  Task.swift
//  Random Day
//
//  Created by Emma Labbé on 23-04-21.
//

import Foundation

struct Task: Codable, Equatable, Hashable, Identifiable {
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.name == rhs.name && lhs.duration == rhs.duration && lhs.startTime == rhs.startTime
    }
    
    enum State {
        case past
        case present
        case future
    }
    
    var name: String
    
    var duration: TimeInterval
    
    var startTime: TimeInterval?
    
    enum Keys: CodingKey {
        case name
        case duration
        case startTime
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(name, forKey: .name)
        try container.encode(duration, forKey: .duration)
        try container.encode(startTime, forKey: .startTime)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        name = try container.decode(String.self, forKey: .name)
        duration = try container.decode(TimeInterval.self, forKey: .duration)
        do {
            startTime = try container.decode(TimeInterval.self, forKey: .startTime)
        } catch {
            startTime = nil
        }
    }
    
    init(name: String, duration: TimeInterval, startTime: TimeInterval? = nil) {
        self.name = name
        self.duration = duration
        self.startTime = startTime
    }
    
    var id: UUID {
        return UUID()
    }
    
    let dayManager = CurrentDayManager.shared
    
    func formattedStartTime(for day: Day) -> String {
        
        guard let startTime = startTime else {
            return ""
        }
        
        let date = day.date.addingTimeInterval(startTime)
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func formattedEndTime(for day: Day) -> String {
        
        guard let startTime = startTime else {
            return ""
        }
        
        let date = day.date.addingTimeInterval(startTime+duration)
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func state(for day: Day) -> State {
        
        guard Bundle.main.bundleURL.pathExtension != "appex" else {
            return .present
        }
        
        guard let startTime = startTime else {
            return .future
        }
        
        let currentTime = Date().timeIntervalSince(day.date)
        let endTime = startTime+duration
        if startTime > currentTime {
            return .future
        } else if endTime < currentTime {
            return .past
        } else {
            return .present
        }
    }
}
