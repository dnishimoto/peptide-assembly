//
//  Peptide_AssemblyApp.swift
//  Peptide Assembly
//
//  Created by David Nishimoto on 9/15/26.
//

import SwiftUI
import CoreData

@main
struct Peptide_AssemblyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
