//
//  ExerciseGoalProgressView.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/12/22.
//

import SwiftUI

struct ExerciseDetailsGoalProgressView: View {
    @ObservedObject var viewModel: ExerciseDetailsViewModel

    var body: some View {
        if let highestRepSetWeight = viewModel.exercise.highestRepSetWeight {

            // Goal achieved
            if highestRepSetWeight >= viewModel.exercise.goalWeight {
                ProgressView(
                    // Prevents runtime error for providing value higher than total value
                    value: Double(viewModel.exercise.goalWeight),
                    total: Double(viewModel.exercise.goalWeight),
                    label: {
                        Text("You achieved your goal!")
                    },
                    currentValueLabel: {
                        Text("Set a new goal by tapping the edit button.")
                    }
                )
                .accessibilityIdentifier(AccessibilityIdentifiers.exerciseDetailsAchievedGoalProgressView)
                .tint(.green)
                
            // Goal not achieved
            } else {
                ProgressView(
                    value: Double(highestRepSetWeight),
                    total: Double(viewModel.exercise.goalWeight),
                    label: {
                        Text("Keep pushing towards your goal!")
                    },
                    currentValueLabel: {
                        Text("\(viewModel.exercise.distanceFromGoalWeight!) more \(viewModel.exercise.unwrappedGoalWeightUnit) to go!")
                    }
                )
                .accessibilityIdentifier(AccessibilityIdentifiers.exerciseDetailsBelowGoalProgressView)
            }
        }
    }
}

struct ExerciseGoalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailsGoalProgressView(
            viewModel: ExerciseDetailsViewModel(
                dataController: DataController.preview,
                exercise: Exercise.example
            )
        )
    }
}
