//
//  ExerciseDetailsViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import Foundation

class ExerciseDetailsViewModel: ObservableObject {
    let exercise: Exercise
    
    init(exercise: Exercise) {
        self.exercise = exercise
    }
}
