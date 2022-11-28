//
//  RepBuddyApp.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import SwiftUI

@main
struct RepBuddyApp: App {
    let dataController = DataController.shared

    var body: some Scene {
        WindowGroup {
            RootView(dataController: dataController)
        }
    }
}
