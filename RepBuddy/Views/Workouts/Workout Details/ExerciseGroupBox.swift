//
//  ExerciseGroupBox.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/30/22.
//

import SwiftUI

struct ExerciseGroupBox: View {
    @ObservedObject var viewModel: WorkoutDetailsViewModel
    @ObservedObject var sheetNavigator: WorkoutDetailsViewSheetNavigator

    let exercise: Exercise

    var body: some View {
        GroupBox {
            HStack {
                Text(exercise.unwrappedName)
                    .font(.title2)

                Spacer()

                Button(role: .destructive) {
                    viewModel.deleteExercise(exercise)
                } label: {
                    Image(systemName: "trash")
                }

                Button("Add Set") {
                    viewModel.setupExerciseController(with: exercise)
                    sheetNavigator.addSetButtonTapped(for: exercise)
                }
            }
            .buttonStyle(.bordered)

            ExerciseSetChart(viewModel: viewModel, exercise: exercise)

            ExerciseRepsList(viewModel: viewModel, sheetNavigator: sheetNavigator, exercise: exercise)
                .padding(.top, 5)
        }
    }
}

struct ExerciseGroupBox_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseGroupBox(
            viewModel: WorkoutDetailsViewModel(
                dataController: DataController.preview,
                workout: Workout.example
            ),
            sheetNavigator: WorkoutDetailsViewSheetNavigator(
                dataController: DataController.preview,
                workout: Workout.example
            ),
            exercise: Exercise.example
        )
    }
}
