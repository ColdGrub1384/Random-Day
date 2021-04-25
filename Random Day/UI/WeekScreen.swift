//
//  WeekScreen.swift
//  Random Day
//
//  Created by Emma Labbé on 23-04-21.
//

import SwiftUI

struct WeekScreen: View {
        
    @State var selectedWeekday: Weekday?
    
    private var completionHandler: ((Weekday) -> ())?
    
    func onSelect(_ completionHandler: @escaping ((Weekday) -> ())) -> some View {
        var new = self
        new.completionHandler = completionHandler
        return new
    }
    
    var body: some View {
        List {
            ForEach(Weekday.all, id: \.self) { weekday in
                Button(action: {
                    if let handler = completionHandler {
                        handler(weekday)
                    } else {
                        selectedWeekday = weekday
                    }
                }, label: {
                    Label(
                        title: { Text(weekday.description) },
                        icon: { Image(systemName: "\(weekday.rawValue).square") })
                }).padding(.vertical)
            }
        }.navigationTitle("Semana").sheet(item: $selectedWeekday) { weekday in
            NavigationView {
                DayPlanner(weekday: weekday, selectedWeekday: $selectedWeekday)
            }
        }.navigationBarTitleDisplayMode(completionHandler == nil ? .large : .automatic)
    }
}

struct WeekScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WeekScreen()
        }
    }
}
