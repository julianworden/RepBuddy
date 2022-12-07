//
//  RepSetsList.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/5/22.
//

import SwiftUI

struct RepSetsListView: View {
    @StateObject private var viewModel: RepSetsListViewModel

    init(
        dataController: DataController,
        workout: Workout,
        exercise: Exercise,
        repSets: [RepSet]
    ) {
        _viewModel = StateObject(wrappedValue: RepSetsListViewModel(dataController: dataController, workout: workout, exercise: exercise, repSets: repSets))
    }

    var body: some View {
        Group {
            switch viewModel.viewState {
            case .dataLoading:
                ProgressView()

            case .dataLoaded:
                RepSetsList(viewModel: viewModel)
                    // If sheet is on Group instead, dismiss animation does not work when deleting the last RepSet
                    .sheet(isPresented: $viewModel.addEditRepSetSheetIsShowing) {
                        AddEditRepSetView(
                            dataController: viewModel.dataController,
                            workout: viewModel.workout,
                            exercise: viewModel.exercise,
                            repSetToEdit: viewModel.repSetToEdit
                        )
                    }

            case .dataNotFound:
                NoDataFoundView(message: "You don't have any sets for this workout's exercise. Use the plus button to add one!")

            default:
                NoDataFoundView(message: "Invalid ViewState")
            }
        }
        .navigationTitle("Sets")
        .onAppear {
            viewModel.setUpExerciseController()
            viewModel.fetchRepSet(in: viewModel.exercise, and: viewModel.workout)
        }
    }
}

struct RepSetsListView_Previews: PreviewProvider {
    static var previews: some View {
        RepSetsListView(
            dataController: DataController.preview,
            workout: Workout.example,
            exercise: Exercise.example,
            repSets: []
        )
    }
}
