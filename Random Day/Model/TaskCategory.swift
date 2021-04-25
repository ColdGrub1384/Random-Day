//
//  TaskCategory.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import SwiftUI

struct TaskCategory: Codable, Hashable, Identifiable {
    
    static func == (lhs: TaskCategory, rhs: TaskCategory) -> Bool {
        return lhs.name == rhs.name && lhs.tasks == rhs.tasks
    }
        
    var name: String
    
    var tasks: [Task]
    
    init(name: String, tasks: [Task]) {
        self.name = name
        self.tasks = tasks
    }
    
    enum CodingKeys: CodingKey {
        case name
        case tasks
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(tasks, forKey: .tasks)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        tasks = try container.decode([Task].self, forKey: .tasks)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(tasks)
    }
    
    var id: UUID {
        return UUID()
    }
}


let previewCategories = [TaskCategory(name: "Jugar", tasks: [
    Task(name: "Jugar Minecraft", duration: 60*60*2),
    Task(name: "Jugar Pokemon", duration: 60*60*2)
])]
