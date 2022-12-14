//
//  ExercisesViewGoalProgressView.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/13/22.
//

import SwiftUI

// TODO: ADD A VIEWMODEL FOR THIS SO THAT THE PROGRESSVIEW WILL UPDATE IN REALTIME
struct ExercisesViewGoalProgressView: View {
    @StateObject private var viewModel: ExercisesViewGoalProgressViewModel

    init(dataController: DataController, exercise: Exercise) {
        _viewModel = StateObject(wrappedValue: ExercisesViewGoalProgressViewModel(dataController: dataController, exercise: exercise))
    }

    var body: some View {
        Group {
            if let highestRepSetWeight = viewModel.exercise.highestRepSetWeight {

                // Goal achieved
                if highestRepSetWeight >= viewModel.exercise.goalWeight {
                    ProgressView(
                        // Prevents runtime error for providing value higher than total value
                        value: Double(viewModel.exercise.goalWeight),
                        total: Double(viewModel.exercise.goalWeight)
                    )
                    .tint(.green)

                // Goal not achieved
                } else {
                    ProgressView(
                        value: Double(highestRepSetWeight),
                        total: Double(viewModel.exercise.goalWeight)
                    )
                }
            }
        }
        .alert(
            "Error",
            isPresented: $viewModel.errorAlertIsShowing,
            actions: {
                Button("OK") { }
            },
            message: {
                Text(viewModel.errorAlertText)
            }
        )
        .onAppear(perform: viewModel.setupExerciseController)
    }
}

struct ExercisesViewGoalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesViewGoalProgressView(dataController: DataController.preview, exercise: Exercise.example)
    }
}
