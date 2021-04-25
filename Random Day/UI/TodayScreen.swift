//
//  TodayScreen.swift
//  Random Day
//
//  Created by Emma Labbé on 23-04-21.
//

import SwiftUI

struct TodayScreen: View {
    
    @ObservedObject var dayManager = CurrentDayManager.shared
    
    var body: some View {
        VStack {
            
            if dayManager.today.tasks.count == 0 {
                Text("No tienes ninguna actividad planeada para los días \(dayManager.weekday!). Agrega actividades en los días de la semana.").padding()
                Spacer()
            }
            
            List {
                ForEach(dayManager.today.tasks, id: \.id) { task in
                    task.padding(.vertical, 5)
                }
            }
        }.navigationTitle("Hoy").onAppear {
            dayManager.startUpdateTimer()
        }.onDisappear {
            dayManager.stopUpdateTimer()
        }
    }
}

struct TodayScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TodayScreen()
        }.onAppear {
            CurrentDayManager.shared.today = previewDay
        }
    }
}
