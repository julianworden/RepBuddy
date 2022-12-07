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
    }
}

struct RepSetsList_Previews: PreviewProvider {
    static var previews: some View {
        RepSetsList(viewModel: RepSetsListViewModel(dataController: DataController.preview, workout: Workout.example, exercise: Exercise.example, repSets: []))
    }
}
