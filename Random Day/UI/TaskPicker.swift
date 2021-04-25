//
//  TaskPicker.swift
//  Random Day
//
//  Created by Emma Labbé on 24-04-21.
//

import SwiftUI

fileprivate class CategoryExpansionManager: ObservableObject {
    
    var isCategoryExpanded = [TaskCategory : Binding<Bool>]()
    
    @Published private var _isCategoryExpanded = [TaskCategory : Bool]() {
        didSet {
            objectWillChange.send()
        }
    }
    
    init() {
        for category in DatabaseManager.shared.database.taskCategories {
            
            _isCategoryExpanded[category] = true
            isCategoryExpanded[category] = .init(get: { () -> Bool in
                return self._isCategoryExpanded[category] ?? true
            }, set: { (newValue) in
                self._isCategoryExpanded[category] = newValue
            })
        }
    }
}

struct TaskPicker: View {
    
    @ObservedObject private var expansionManager = CategoryExpansionManager()
    
    @State var isPresentingErrorMessage = false
    
    @State private var selection: Task?
    
    @State private var selectedDate = Date()
    
    var activeSheet: Binding<DayPlanner.ActiveSheet?>
        
    var weekday: Weekday
    
    let manager = DatabaseManager.shared
    
    var body: some View {
        VStack {
            if manager.database.taskCategories.count == 0 {
                Text("No tienes ninguna actividad creada. Crea actividades desde la sección \"Actividades\".").padding()
                Spacer()
            } else {
                DatePicker("A que hora quieres empezar la actividad?", selection: $selectedDate, displayedComponents: .hourAndMinute).padding()
                
                List {
                    ForEach(manager.database.taskCategories, id: \.id) { category in

                        DisclosureGroup(
                            isExpanded: expansionManager.isCategoryExpanded[category]!, content: {
                                ForEach(category.tasks, id: \.id) { task in
                                    Button(action: {
                                        if selection == task {
                                            selection = nil
                                        } else {
                                            selection = task
                                        }
                                    }, label: {
                                        HStack {
                                            Text(task.name)
                                            Spacer()
                                            
                                            if selection == task {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    })
                                }
                            },
                            label: {
                                Text(Image(systemName: "folder")) + Text(" ") + Text(category.name)
                        })
                    }
                }
            }
        }
        .navigationBarItems(leading: Button(action: {
            activeSheet.wrappedValue = nil
        }, label: {
            Text("Cancelar")
        }), trailing: Button(action: {
            if let selection = selection {
                activeSheet.wrappedValue = nil
                
                var tasks = manager.database.plannedDays[weekday]?.tasks ?? []
                tasks.append(FutureTask(staticTask: selection, startTime: selectedDate.timeIntervalSince(Calendar.current.startOfDay(for: selectedDate))))
                manager.database.plannedDays[weekday] = PlannedDay(weekday: weekday, tasks: tasks)
            } else {
                isPresentingErrorMessage = true
            }
        }, label: {
            Text("OK")
        }))
        .alert(isPresented: $isPresentingErrorMessage, content: {
            Alert(title: Text("Error"), message: Text("Selecciona una categoría."), dismissButton: .cancel())
        })
        .navigationTitle("Seleccionar actividad")
    }
}

struct TaskPicker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaskPicker(activeSheet: .constant(.constant), weekday: .monday)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
