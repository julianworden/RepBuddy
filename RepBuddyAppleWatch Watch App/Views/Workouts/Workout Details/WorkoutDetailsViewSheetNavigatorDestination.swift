//
//  WorkoutDetailsViewSheetNavigatorDestination.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/30/22.
//

import Foundation

enum WorkoutDetailsViewSheetNavigatorDestination {
    case none
    case addEditWorkoutView(workoutToEdit: Workout)
    case addExerciseView
}
