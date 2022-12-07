//
//  RepSetsList.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/5/22.
//

import SwiftUI

struct RepSetsListView: View {
    @Environment(\.dismiss) var dismiss

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
        ZStack {
            switch viewModel.viewState {
            case .dataLoading:
                ProgressView()

            case .dataLoaded:
                RepSetsList(viewModel: viewModel)
                    // If sheet is on Group instead, dismiss animation does not work when deleting the last RepSet

            case .dataDeleted:
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
            viewModel.fetchRepSet(in: viewModel.exercise, and: viewModel.workout)
        }
        .onChange(of: viewModel.dismissView) { _ in
            dismiss()
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
