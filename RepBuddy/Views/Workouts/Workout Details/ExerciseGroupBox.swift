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
                VStack {
                    HStack {
                        Text(exercise.unwrappedName)
                            .font(.title2)

                        Spacer()

                        Button(role: .destructive) {
                            viewModel.deleteExerciseInWorkoutAlertIsShowing.toggle()
                        } label: {
                            Image(systemName: "trash")
                        }
                        .alert("Are You Sure?", isPresented: $viewModel.deleteExerciseInWorkoutAlertIsShowing) {
                            Button("Cancel", role: .cancel) { }
                            Button("Yes", role: .destructive) { viewModel.deleteExercise(exercise) }
                        } message: {
                            Text(AlertConstants.deleteExerciseInWorkoutMessage)
                        }

                        Button("Add Set") {
                            viewModel.setupExerciseController(with: exercise)
                            sheetNavigator.addSetButtonTapped(for: exercise)
                        }
                    }
                    .buttonStyle(.bordered)

                    ExerciseSetChart(
                        repSets: viewModel.fetchRepSet(in: exercise, and: viewModel.workout),
                        exercise: exercise
                    )
                }

                Image(systemName: "chevron.right")
            }
        }
    }
}

struct ExerciseGroupBox_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            ForEach(0..<2) { int in
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
    }
}
