//
//  Tabs.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import SwiftUI

struct Tabs: View {
    
    @AppStorage("selection") var selection = SelectedSectionHolder()
    
    var body: some View {
        TabView {
            NavigationView {
                TodayScreen()
            }.navigationViewStyle(StackNavigationViewStyle()).tabItem {
                Image(systemName: "clock")
                Text("Hoy")
            }.tag(SelectedSection.today)
            
            NavigationView {
                WeekScreen()
            }.navigationViewStyle(StackNavigationViewStyle()).tabItem {
                Image(systemName: "calendar")
                Text("Semana")
            }.tag(SelectedSection.week)
            
            TaskCategoriesScreen().ignoresSafeArea().tabItem {
                Image(systemName: "pencil")
                Text("Actividades")
            }.tag(SelectedSection.tasks)
        }
    }
}

struct Tabs_Previews: PreviewProvider {
    static var previews: some View {
        Tabs()
    }
}
