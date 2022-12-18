//
//  RootView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import SwiftUI

struct RootView: View {
    @StateObject private var viewModel: RootViewModel

    init(dataController: DataController) {
        _viewModel = StateObject(wrappedValue: RootViewModel(dataController: dataController))
    }
    
    var body: some View {
        TabView {
            ExercisesView(dataController: viewModel.dataController)
                .tabItem {
                    Label("Exercises", systemImage: "figure.run")
                }

            WorkoutsView(dataController: viewModel.dataController)
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
