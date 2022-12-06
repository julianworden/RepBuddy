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
        if !viewModel.repSets.isEmpty {
            RepSetsList(viewModel: viewModel)
        } else {
            NoDataFoundView(message: "You don't have any sets for this workout's exercise. Use the plus button to add one!")
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
