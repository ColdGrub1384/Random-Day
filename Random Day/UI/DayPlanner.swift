//
//  PlannedDay.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import SwiftUI

fileprivate let dayManager = CurrentDayManager.shared

struct DayPlanner: View {
    
    enum ActiveSheet: Identifiable {
        case random, constant, copyDay
        
        var id: Int {
            hashValue
        }
    }
    
    @State var activeSheet: ActiveSheet?
    
    var weekday: Weekday
    
    @ObservedObject var manager = DatabaseManager.shared
    
    @State var presentingAddTask = false
    
    var selectedWeekday: Binding<Weekday?>
    
    var body: some View {
        
        VStack {
            if manager.database.plannedDays[weekday] == nil || manager.database.plannedDays[weekday]?.tasks.count == 0 {
                Text("No tienes nada planeado para los \(weekday.description)\(weekday.description.hasSuffix("s") ? "" : "s"). Agrega una actividad o copialas de otro día.").padding()
            }
            
            HStack {
                Button(action: {
                    activeSheet = .copyDay
                }, label: {
                    Text("Copiar un día")
                }).padding()
                Spacer()
            }
            
            if manager.database.plannedDays[weekday] == nil || manager.database.plannedDays[weekday]?.tasks.count == 0 {
                
                Spacer()
            }
            
            List {
                ForEach(manager.database.plannedDays[weekday]?.tasks ?? [], id: \.id) { task in
                    task.onDelete {
                        guard var day = manager.database.plannedDays[weekday] else {
                            return
                        }
                        
                        guard let i = day.tasks.firstIndex(of: task) else {
                            return
                        }
                        
                        day.tasks.remove(at: i)
                        
                        manager.database.plannedDays[weekday] = day
                    }.padding(.vertical)
                }
            }
        }
        .navigationTitle(weekday.description)
        .navigationBarItems(leading: Button(action: {
                presentingAddTask = true
            }, label: {
                Image(systemName: "plus").padding([.trailing, .vertical])
            }).actionSheet(isPresented: $presentingAddTask) {
                ActionSheet(title: Text("Agregar actividad"), message: Text("Si una actividad es aleatoria, podrá elegir algunas categorías de actividades para que la aplicación eliga una actividad por tí aleatoriamente."), buttons: [
                    .default(Text("Aleatorio")) { activeSheet = .random },
                    .default(Text("Estático")) { activeSheet = .constant },
                    .cancel()
                ])
            }, trailing: Button(action: {
                selectedWeekday.wrappedValue = nil
            }, label: {
                Text("OK")
            })).sheet(item: $activeSheet, content: { item in
                NavigationView {
                    switch item {
                    case .random:
                        TaskCategoryPicker(activeSheet: $activeSheet, weekday: weekday).navigationBarTitleDisplayMode(.inline)
                    case .constant:
                        TaskPicker(activeSheet: $activeSheet, weekday: weekday).navigationBarTitleDisplayMode(.inline)
                    case .copyDay:
                        WeekScreen().onSelect { weekday in
                            
                            activeSheet = nil
                            
                            guard var day = manager.database.plannedDays[weekday] else {
                                return
                            }
                            
                            day.weekday = self.weekday
                            manager.database.plannedDays[self.weekday] = day
                        }.navigationBarItems(trailing: Button(action: {
                            activeSheet = nil
                        }, label: {
                            Text("Cancelar")
                        }))
                    }
                }.navigationViewStyle(StackNavigationViewStyle())
            })
    }
}

struct DayPlanner_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DayPlanner(weekday: .monday, selectedWeekday: .constant(nil))
        }.navigationViewStyle(StackNavigationViewStyle()).onAppear {
            DatabaseManager.shared.database.plannedDays = [.monday: PlannedDay(weekday: .monday, tasks: [
                FutureTask(categories: ["Jugar", "a"], startTime: 0),
                FutureTask(staticTask: Task(name: "a", duration: 60*60*1), startTime: 60*60*2)
            ])]
        }
    }
}
