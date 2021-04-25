//
//  Weekday.swift
//  Random Day
//
//  Created by Emma Labbé on 23-04-21.
//

import Foundation

enum Weekday: Int, Codable, Identifiable {
    
    var id: Int {
        return rawValue
    }
    
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
    
    var description: String {
        switch self {
        case .monday:
            return "Lunes"
        case .tuesday:
            return "Martes"
        case .wednesday:
            return "Miércoles"
        case .thursday:
            return "Jueves"
        case .friday:
            return "Viernes"
        case .saturday:
            return "Sábado"
        case .sunday:
            return "Domingo"
        }
    }
    
    init?(date: Date) {
        var rawValue = Calendar.current.component(.weekday, from: date)-1
        if rawValue == 0 {
            rawValue = 7
        }
        
        if let weekday = Weekday(rawValue: rawValue) {
            self = weekday
        } else {
            return nil
        }
    }
    
    static let all: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
}
