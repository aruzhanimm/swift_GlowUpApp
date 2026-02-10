//
//  GlowUpApp.swift
//  GlowUp
//
//  Created by Аружан Картам on 10.02.2026.
//

import SwiftUI
import CoreData

@main
struct GlowUpApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
