//
//  RepBuddyAppleWatchApp.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import SwiftUI

@main
struct RepBuddyAppleWatch_Watch_AppApp: App {
    let dataController = DataController.shared

    var body: some Scene {
        WindowGroup {
            RootView(dataController: dataController)
        }
    }
}
