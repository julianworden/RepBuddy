//
//  RepSetsList.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/6/22.
//

import SwiftUI

struct RepSetsList: View {
    @ObservedObject var viewModel: RepSetsListViewModel

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
        RepSetsList(viewModel: RepSetsListViewModel(dataController: DataController.preview, workout: Workout.example, exercise: Exercise.example, repSets: []))
    }
}
