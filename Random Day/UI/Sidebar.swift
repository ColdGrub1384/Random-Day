//
//  Sidebar.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import SwiftUI

extension View {
    
    var transparentRowBackground: some View {
        if ProcessInfo.processInfo.isMacCatalystApp {
            return AnyView(listRowBackground(Color.clear))
        } else {
            return AnyView(self)
        }
    }
}

struct Sidebar: View {
    
    @AppStorage("selection") var selection = SelectedSectionHolder()
    
    var body: some View {
        List {
            NavigationLink(
                destination: TodayScreen(),
                tag: SelectedSection.today,
                selection: $selection.selectedSection,
                label: {
                    Label(
                        title: { Text("Hoy") },
                        icon: { Image(systemName: "clock") })
                }
            ).transparentRowBackground
            
            NavigationLink(
                destination: WeekScreen(),
                tag: SelectedSection.week,
                selection: $selection.selectedSection,
                label: {
                    Label(
                        title: { Text("Semana") },
                        icon: { Image(systemName: "calendar") })
                }
            ).transparentRowBackground
            
            NavigationLink(
                destination: TaskCategoriesScreen().navigationBarHidden(true),
                tag: SelectedSection.tasks,
                selection: $selection.selectedSection,
                label: {
                    Label(
                        title: { Text("Actividades") },
                        icon: { Image(systemName: "pencil") })
                }
            ).transparentRowBackground
        }.listStyle(SidebarListStyle()).navigationTitle("Random Day").onAppear() {
            if ProcessInfo.processInfo.isMacCatalystApp {
                UITableViewCell.appearance().backgroundColor = UIColor.clear
            }
        }
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
