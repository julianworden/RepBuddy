//
//  ExerciseRepsList.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/28/22.
//

import SwiftUI

struct ExerciseRepsList: View {
    @ObservedObject var viewModel: WorkoutDetailsViewModel
    @ObservedObject var sheetNavigator: WorkoutDetailsViewSheetNavigator

    let exercise: Exercise

    var body: some View {
        VStack(spacing: 10) {
            ForEach(exercise.repSetArray) { repSet in
                if repSet.workout == viewModel.workout {
                    HStack {
                        Text(repSet.formattedDescription)

                        Spacer()

                        Button {
                            sheetNavigator.editSetButtonTapped(for: repSet, in: exercise)
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .onDelete { indexSet in
                viewModel.deleteRepSet(in: exercise, at: indexSet)
            }
        }
    }
}

struct ExerciseRepsList_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRepsList(
            viewModel: WorkoutDetailsViewModel(
                dataController: DataController.preview,
                workout: Workout.example),
            sheetNavigator: WorkoutDetailsViewSheetNavigator(
                dataController: DataController.preview,
                workout: Workout.example
            ),
            exercise: Exercise.example
        )
    }
}
