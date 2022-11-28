//
//  WorkoutDetailsViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import Foundation

class WorkoutDetailsViewModel: ObservableObject {
    let workout: Workout
    
    init(workout: Workout) {
        self.workout = workout
    }
}
