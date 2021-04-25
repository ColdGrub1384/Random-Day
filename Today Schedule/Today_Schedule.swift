//
//  Today_Schedule.swift
//  Today Schedule
//
//  Created by Emma Labbé on 25-04-21.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), task: Task(name: "", duration: 0))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), task: Task(name: "Ver una serie", duration: 60*60*2, startTime: Date().timeIntervalSince(Calendar.current.startOfDay(for: Date()))))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let todayDate = Calendar.current.startOfDay(for: Date())
        for task in CurrentDayManager.shared.today.tasks {
            let entryDate: Date
            if entries.count == 0 {
                entryDate = todayDate.addingTimeInterval(task.startTime ?? 0)
            } else {
                entryDate = todayDate.addingTimeInterval(entries.last!.task.startTime ?? 0).addingTimeInterval(entries.last!.task.duration)
            }
            let entry = SimpleEntry(date: entryDate, task: task)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let task: Task
}

struct Today_ScheduleEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        entry.task.padding()
    }
}

@main
struct Today_Schedule: Widget {
    let kind: String = "Today_Schedule"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Today_ScheduleEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Random Day")
        .description("Muestra lo que tienes que hacer hoy.")
    }
}

struct Today_Schedule_Previews: PreviewProvider {
    static var previews: some View {
        Today_ScheduleEntryView(entry: SimpleEntry(date: Date(), task: Task(name: "", duration: 0)))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
