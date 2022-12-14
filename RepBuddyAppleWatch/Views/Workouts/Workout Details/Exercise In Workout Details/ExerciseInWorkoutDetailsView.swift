//
//  ExerciseInWorkoutDetailsView.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/2/22.
//

import SwiftUI

/// The view that's presented when an exercise is selected within WorkoutDetailsView.
struct ExerciseInWorkoutDetailsView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel: ExerciseInWorkoutDetailsViewModel

    init(dataController: DataController, exercise: Exercise, workout: Workout) {
        _viewModel = StateObject(wrappedValue: ExerciseInWorkoutDetailsViewModel(dataController: dataController, exercise: exercise, workout: workout))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                HStack {
                    Text(viewModel.exercise.unwrappedName)
                        .font(.title3.bold())
                        .multilineTextAlignment(.leading)

                    Spacer()
                }
                .buttonStyle(.plain)

                HStack {
                    NavigationLink {
                        ExerciseRepsInWorkoutDetailsView(
                            dataController: viewModel.dataController,
                            workout: viewModel.workout,
                            exercise: viewModel.exercise,
                            repSets: viewModel.exerciseRepSets
                        )
                    } label: {
                        HStack {
                            ExerciseSetChart(viewModel: viewModel, exercise: viewModel.exercise)
                                // Without this, a line on the chart will go off the leading edge of the screen
                                .padding(.leading, 5)
                                .accessibilityIdentifier(AccessibilityIdentifiers.exerciseSetChart)

                            Image(systemName: "chevron.right")
                        }
                    }
                    .buttonStyle(.plain)
                }

                Button("Create Set") {
                    viewModel.addEditRepSetSheetIsShowing.toggle()
                }
                .tint(.blue)

                Button("Delete Exercise", role: .destructive) {
                    viewModel.deleteExerciseAlertIsShowing.toggle()
                }
                .alert("Are You Sure?", isPresented: $viewModel.deleteExerciseAlertIsShowing) {
                    Button("Yes", role: .destructive) { viewModel.deleteExercise(); dismiss() }
                } message: {
                    Text(AlertConstants.deleteExerciseInWorkoutMessage)
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.addEditRepSetSheetIsShowing) {
            AddEditRepSetView(
                dataController: viewModel.dataController,
                workout: viewModel.workout,
                exercise: viewModel.exercise
            )
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
        .onAppear {
            viewModel.setupExerciseController()
        }
    }
}

struct ExerciseInWorkoutDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseInWorkoutDetailsView(
            dataController: DataController.preview,
            exercise: Exercise.example,
            workout: Workout.example
        )
    }
}
