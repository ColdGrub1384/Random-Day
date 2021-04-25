//
//  Task+View.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import SwiftUI

extension Task: View {
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(formattedStartTime(for: dayManager.today)).fontWeight(.light)
                    Text(name).font(Bundle.main.bundleURL.pathExtension == "appex" ? .body : .title3).fontWeight(state(for: dayManager.today) == .present ? .bold : .regular).padding(.vertical, 5)
                    Text(formattedEndTime(for: dayManager.today)).fontWeight(.light)
                }
                Spacer()
                if Bundle.main.bundleURL.pathExtension != "appex" {
                    switch state(for: dayManager.today) {
                    case .past:
                        Image(systemName: "checkmark").foregroundColor(.green)
                    case .present:
                        Text(dayManager.today.date.addingTimeInterval((startTime ?? 0)+duration), style: .timer)
                    case .future:
                        EmptyView()
                    }
                }
            }
        }
    }
}
