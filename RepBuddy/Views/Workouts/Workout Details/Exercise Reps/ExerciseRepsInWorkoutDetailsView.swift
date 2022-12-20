//
//  ExerciseRepsInWorkoutDetailsView.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/8/22.
//

import SwiftUI

/// The View displayed when an exercise is selected from within WorkoutDetailsView
struct ExerciseRepsInWorkoutDetailsView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel: ExerciseRepsViewModel

    @State private var editMode = EditMode.inactive

    init(
        dataController: DataController,
        workout: Workout,
        exercise: Exercise,
        repSets: [RepSet]
    ) {
        _viewModel = StateObject(wrappedValue: ExerciseRepsViewModel(dataController: dataController, workout: workout, exercise: exercise, repSets: repSets))
    }

    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .dataLoading:
                ProgressView()

            case .dataLoaded:
                List {
                    ForEach(viewModel.exercise.repSetArray) { repSet in
                        if repSet.workout == viewModel.workout {
                            Button {
                                viewModel.editRepSetSheetIsShowing.toggle()
                            } label: {
                                Text(repSet.formattedDescription)
                            }
                            .tint(.primary)
                            .sheet(isPresented: $viewModel.editRepSetSheetIsShowing) {
                                AddEditRepSetView(
                                    dataController: viewModel.dataController,
                                    workout: viewModel.workout,
                                    exercise: viewModel.exercise,
                                    repSetToEdit: repSet
                                )
                            }
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.deleteRepSet(in: viewModel.exercise, at: indexSet)

                        if viewModel.exercise.repSetArray.isEmpty {
                            $editMode.wrappedValue = .inactive
                        }
                    }
                }

            case .error:
                EmptyView()

            case .dataNotFound:
                NoDataFoundView(message: "You haven't added any sets to this exercise. Use the plus button to add one!")
                    .padding(.horizontal)

            default:
                NoDataFoundView(message: "Invalid ViewState")
            }
        }
        .navigationTitle("Sets")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !viewModel.exercise.repSetArray.isEmpty {
                ToolbarItem {
                    EditButton()
                }
            }

            ToolbarItem {
                Button {
                    viewModel.addRepSetSheetIsShowing.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .environment(\.editMode, $editMode)
        .sheet(isPresented: $viewModel.addRepSetSheetIsShowing) {
            AddEditRepSetView(
                dataController: viewModel.dataController,
                workout: viewModel.workout,
                exercise: viewModel.exercise
            )
        }
        .onAppear {
            viewModel.setUpExerciseController()
            viewModel.fetchRepSet(in: viewModel.exercise, and: viewModel.workout)
        }
    }
}

struct ExerciseRepsView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRepsInWorkoutDetailsView(dataController: DataController.preview, workout: Workout.example, exercise: Exercise.example, repSets: [])
    }
}
