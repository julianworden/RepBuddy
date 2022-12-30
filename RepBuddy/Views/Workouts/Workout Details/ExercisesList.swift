//
//  ExercisesList.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/29/22.
//

import Charts
import SwiftUI

struct ExercisesList: View {
    @ObservedObject var viewModel: WorkoutDetailsViewModel
    @ObservedObject var sheetNavigator: WorkoutDetailsViewSheetNavigator
    
    var body: some View {
        ForEach(viewModel.workoutExercises) { exercise in
            NavigationLink {
                ExerciseRepsInWorkoutDetailsView(
                    dataController: viewModel.dataController,
                    workout: viewModel.workout,
                    exercise: exercise,
                    repSets: exercise.repSetsArray
                )
            } label: {
                ExerciseGroupBox(
                    viewModel: viewModel,
                    sheetNavigator: sheetNavigator,
                    exercise: exercise
                )
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier(exercise.unwrappedName)
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
