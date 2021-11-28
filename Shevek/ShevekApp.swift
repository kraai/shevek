//
//  ShevekApp.swift
//  Shevek
//
//  Created by Matthew James Kraai on 11/28/21.
//

import SwiftUI

@main
struct ShevekApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
