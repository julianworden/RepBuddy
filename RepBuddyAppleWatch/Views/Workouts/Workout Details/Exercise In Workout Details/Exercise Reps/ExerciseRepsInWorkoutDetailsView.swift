//
//  ExerciseRepsInWorkoutDetailsView.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/5/22.
//

import SwiftUI

struct ExerciseRepsInWorkoutDetailsView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel: ExerciseRepsInWorkoutDetailsViewModel

    init(
        dataController: DataController,
        workout: Workout,
        exercise: Exercise,
        repSets: [RepSet]
    ) {
        _viewModel = StateObject(wrappedValue: ExerciseRepsInWorkoutDetailsViewModel(dataController: dataController, workout: workout, exercise: exercise, repSets: repSets))
    }

    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .dataLoading:
                ProgressView()

            case .dataLoaded:
                ExerciseRepsInWorkoutDetailsList(viewModel: viewModel)
                    .toolbar {
                        ToolbarItem {
                            Button("Create Set") {
                                viewModel.addEditRepSetSheetIsShowing.toggle()
                            }
                            .tint(.blue)
                        }
                    }

            case .dataNotFound:
                VStack {
                    NoDataFoundView(message: "You haven't created any sets.")

                    Button("Create Set") {
                        viewModel.addEditRepSetSheetIsShowing.toggle()
                    }
                    .tint(.blue)
                }

            case .error:
                EmptyView()

            default:
                NoDataFoundView(message: "Invalid ViewState")
            }
        }
        .navigationTitle("Sets")
        .sheet(isPresented: $viewModel.addEditRepSetSheetIsShowing) {
            AddEditRepSetView(
                dataController: viewModel.dataController,
                workout: viewModel.workout,
                exercise: viewModel.exercise,
                repSetToEdit: viewModel.repSetToEdit
            )
        }
        .onAppear {
            viewModel.setUpExerciseController()
            viewModel.fetchRepSets(in: viewModel.exercise, and: viewModel.workout)
        }
    }
}

struct RepSetsListView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRepsInWorkoutDetailsView(
            dataController: DataController.preview,
            workout: Workout.example,
            exercise: Exercise.example,
            repSets: []
        )
    }
}
