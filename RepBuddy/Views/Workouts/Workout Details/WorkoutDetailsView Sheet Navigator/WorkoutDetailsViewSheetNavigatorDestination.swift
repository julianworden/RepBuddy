//
//  SheetDestination.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/30/22.
//

import Foundation

/// Helps to implement the WorkoutDetailsViewSheetNavigator by providing different
/// options for which View the navigator will present.
enum WorkoutDetailsViewSheetNavigatorDestination: Equatable {
    case none
    case addEditRepSetView(exercise: Exercise, repSetToEdit: RepSet?)
    case addEditWorkoutView(workoutToEdit: Workout)
    case addExerciseView
}
