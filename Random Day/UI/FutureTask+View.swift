//
//  FutureTask+View.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import SwiftUI

extension FutureTask: View {
    
    func onDelete(_ completionHandler: @escaping (() -> ())) -> some View {
        HStack {
            self
            Spacer()
            Button(action: completionHandler, label: {
                Image(systemName: "trash")
            })
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: categories != nil ? "die.face.5" : "calendar.badge.clock").padding(.horizontal)
                VStack(alignment: .leading) {
                    Text(formattedStartTime(for: CurrentDayManager.shared.today)).fontWeight(.light)
                    Text("\(categories?.joined(separator: ", ") ?? staticTask?.name ?? "")").font(.title3).padding(.vertical, 5)
                    Text(formattedEndTime(for: CurrentDayManager.shared.today)).fontWeight(.light)
                }
                Spacer()
            }
        }
    }
}
