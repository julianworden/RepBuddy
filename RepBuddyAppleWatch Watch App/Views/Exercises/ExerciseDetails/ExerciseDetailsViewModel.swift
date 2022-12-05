//
//  ExerciseDetailsViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import Foundation

class ExerciseDetailsViewModel: ObservableObject {
    @Published var addEditExerciseSheetIsShowing = false

    let dataController: DataController
    let exercise: Exercise
    
    init(dataController: DataController, exercise: Exercise) {
        self.dataController = dataController
        self.exercise = exercise
    }
}
