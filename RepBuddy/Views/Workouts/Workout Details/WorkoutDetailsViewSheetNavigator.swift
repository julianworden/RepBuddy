//
//  WorkoutDetailsViewSheetNavigator.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/29/22.
//

import Foundation
import SwiftUI

class WorkoutDetailsViewSheetNavigator: ObservableObject {
    enum SheetDestination {
        case none
        case addEditRepSetView(exercise: Exercise, repSetToEdit: RepSet?)
        case addEditWorkoutView(workoutToEdit: Workout)
        case addExerciseView
    }

    @Published var presentSheet = false
    var sheetDestination = SheetDestination.none {
        didSet {
            presentSheet.toggle()
        }
    }

    let dataController: DataController
    let workout: Workout
    
    init(dataController: DataController, workout: Workout) {
        self.dataController = dataController
        self.workout = workout
    }
    
    func sheetView() -> AnyView {
        switch sheetDestination {
        case .none:
            return Text("None").eraseToAnyView()

        case .addEditRepSetView(let exercise, let repSetToEdit):
            return AddEditRepSetView(
                dataController: dataController,
                workout: workout,
                exercise: exercise,
                repSetToEdit: repSetToEdit
            ).eraseToAnyView()

        case .addEditWorkoutView(let workoutToEdit):
            return AddEditWorkoutView(
                dataController: dataController,
                workoutToEdit: workoutToEdit
            ).eraseToAnyView()

        case .addExerciseView:
            return AddExerciseView(
                dataController: dataController,
                workout: workout
            ).eraseToAnyView()
        }
    }

    func addExerciseButtonTapped() {
        sheetDestination = .addExerciseView
    }
    
    func editSetButtonTapped(for repSet: RepSet, in exercise: Exercise) {
        sheetDestination = .addEditRepSetView(
            exercise: exercise,
            repSetToEdit: repSet
        )
    }
    
    func editWorkoutButtonTapped() {
        sheetDestination = .addEditWorkoutView(workoutToEdit: workout)
    }
    
    func addSetButtonTapped(for exercise: Exercise) {
        sheetDestination = .addEditRepSetView(
            exercise: exercise,
            repSetToEdit: nil
        )
    }
}
