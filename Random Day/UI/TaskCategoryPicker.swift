//
//  TaskCategoryPicker.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import SwiftUI

fileprivate func containsCategory(_ names: Set<String>, category: TaskCategory) -> Bool {
    
    for name in names {
        if category.name == name {
            return true
        }
    }
    
    return false
}

struct TaskCategoryPicker: View {
    
    let manager = DatabaseManager.shared
    
    @State private var selection = Set<String>()
        
    @State private var selectedDate = Date()
    
    @State private var isPresentingErrorMessage = false
    
    var activeSheet: Binding<DayPlanner.ActiveSheet?>
    
    var weekday: Weekday
    
    var body: some View {
        VStack {
            if DatabaseManager.shared.database.taskCategories.count == 0 {
                Text("No tienes ninguna actividad creada. Crea actividades desde la sección \"Actividades\".").padding()
                Spacer()
            } else {
                
                Text("Se insertará una actividad de una de las categorías seleccionadas aleatoriamente en el horario todos los \(weekday.description)\(weekday.description.hasSuffix("s") ? "" : "s").").padding()
                
                DatePicker("A que hora quieres empezar la actividad?", selection: $selectedDate, displayedComponents: .hourAndMinute).padding()
                
                List(DatabaseManager.shared.database.taskCategories, id: \.id) { category in
                    Button(action: {
                        if selection.contains(category.name) {
                            selection.remove(category.name)
                        } else {
                            selection.insert(category.name)
                        }
                    }, label: {
                        HStack {
                            Text(category.name)
                            Spacer()
                            
                            if containsCategory(selection, category: category) {
                                Image(systemName: "checkmark")
                            }
                        }
                    })
                }
            }
        }.navigationTitle("Seleccionar categoría(s)").navigationBarItems(leading: Button(action: {
            activeSheet.wrappedValue = nil
        }, label: {
            Text("Cancelar")
        }), trailing: Button(action: {
            if selection.count == 0 {
                isPresentingErrorMessage = true
            } else {
                activeSheet.wrappedValue = nil
                var tasks = manager.database.plannedDays[weekday]?.tasks ?? []
                tasks.append(FutureTask(categories: Array(selection), startTime: selectedDate.timeIntervalSince(Calendar.current.startOfDay(for: selectedDate))))
                manager.database.plannedDays[weekday] = PlannedDay(weekday: weekday, tasks: tasks)
            }
        }, label: {
            Text("Crear")
        })).alert(isPresented: $isPresentingErrorMessage, content: {
            Alert(title: Text("Error"), message: Text("Selecciona al menos una categoría."), dismissButton: .cancel())
        })
    }
}

struct TaskCategoryPicker_Previews: PreviewProvider {
    static var previews: some View {
        TaskCategoryPicker(activeSheet: .constant(.random), weekday: .monday)
    }
}
