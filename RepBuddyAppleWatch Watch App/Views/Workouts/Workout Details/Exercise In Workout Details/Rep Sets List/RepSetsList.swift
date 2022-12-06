//
//  RepSetsList.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/5/22.
//

import SwiftUI

struct RepSetsList: View {
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
        List(viewModel.repSets) { repSet in
            Button(repSet.formattedDescription) {
                viewModel.repSetButtonTapped(repSet)
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
        .onAppear(perform: viewModel.setUpExerciseController)
    }
}

struct RepSetsList_Previews: PreviewProvider {
    static var previews: some View {
        RepSetsList(
            dataController: DataController.preview,
            workout: Workout.example,
            exercise: Exercise.example,
            repSets: []
        )
    }
}
