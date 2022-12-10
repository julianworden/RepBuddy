//
//  ExerciseRepsView.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/8/22.
//

import SwiftUI

struct ExerciseRepsView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel: ExerciseRepsViewModel

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
                ExerciseRepsList(viewModel: viewModel, exercise: viewModel.exercise)

            case .error:
                EmptyView()

            case .dataNotFound:
                NoDataFoundView(message: "You haven't added any sets to this exercise. Use the plus button to add one!")

            default:
                NoDataFoundView(message: "Invalid ViewState")
            }
        }
        .navigationTitle("Sets")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.addRepSetSheetIsShowing.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
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
        ExerciseRepsView(dataController: DataController.preview, workout: Workout.example, exercise: Exercise.example, repSets: [])
    }
}
