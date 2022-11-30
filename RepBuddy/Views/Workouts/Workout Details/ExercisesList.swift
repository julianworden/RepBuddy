//
//  ExercisesList.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/29/22.
//

import SwiftUI

struct ExercisesList: View {
    @ObservedObject var viewModel: WorkoutDetailsViewModel
    @ObservedObject var sheetNavigator: WorkoutDetailsViewSheetNavigator

    var body: some View {
        ForEach(viewModel.workoutExercises, id: \.self) { exercise in
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

            if !exercise.repSetArray.isEmpty {
                ExerciseRepsList(viewModel: viewModel, sheetNavigator: sheetNavigator, exercise: exercise)
            }
        }
    }
}

struct ExercisesList_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesList(
            viewModel: WorkoutDetailsViewModel(
                dataController: DataController.preview,
                workout: Workout.example
            ),
            sheetNavigator: WorkoutDetailsViewSheetNavigator(
                dataController: DataController.preview,
                workout: Workout.example
            )
        )
    }
}
