//
//  RepSetsListViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/5/22.
//

import Foundation

class RepSetsListViewModel: ObservableObject {
    @Published var addEditRepSetSheetIsShowing = false

    let dataController: DataController
    let workout: Workout
    let exercise: Exercise
    var repSetToEdit: RepSet?

    var repSets = [RepSet]()

    init(
        dataController: DataController,
        workout: Workout,
        exercise: Exercise,
        repSets: [RepSet]
    ) {
        self.dataController = dataController
        self.workout = workout
        self.exercise = exercise
        self.repSets = repSets
    }

    func repSetButtonTapped(_ repSet: RepSet) {
        repSetToEdit = repSet
        addEditRepSetSheetIsShowing.toggle()
    }
}
