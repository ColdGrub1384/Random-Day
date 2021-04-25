//
//  ContentView.swift
//  Random Day
//
//  Created by Emma Labbé on 23-04-21.
//

import SwiftUI
import UIKit

struct EmptyViewController: UIViewControllerRepresentable {
    
    class ViewController: UIViewController {
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            splitViewController?.preferredDisplayMode = .oneOverSecondary
        }
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct ContentView: View {
        
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .compact {
            Tabs()
        } else {
            NavigationView {
                Sidebar()
                EmptyViewController()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().onAppear {
            CurrentDayManager.shared.today = previewDay
        }
    }
}
