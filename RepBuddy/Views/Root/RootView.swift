//
//  RootView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import SwiftUI

struct RootView: View {
    let dataController: DataController
    
    var body: some View {
        TabView {
            ExercisesView(dataController: dataController)
                .tabItem {
                    Label("Exercises", systemImage: "figure.run")
                }

            WorkoutsView(dataController: dataController)
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell")
                }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(dataController: DataController.preview)
    }
}
