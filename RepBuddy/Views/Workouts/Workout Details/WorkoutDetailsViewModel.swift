//
//  WorkoutDetailsViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import CoreData
import Foundation
import SwiftUI

class WorkoutDetailsViewModel: NSObject, ObservableObject {
    @Published var workoutExercises = [Exercise]()

    @Published var deleteExerciseInWorkoutAlertIsShowing = false

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""
    @Published var dismissView = false

    @Published var viewState = ViewState.displayingView {
        didSet {
            switch viewState {
            case .dataDeleted:
                dismissView.toggle()

            case .error(let message):
                errorAlertIsShowing.toggle()
                errorAlertText = message

            default:
                errorAlertIsShowing.toggle()
                errorAlertText = "Invalid ViewState"
            }
        }
    }

    let dataController: DataController
    let workout: Workout

    var workoutController: NSFetchedResultsController<Workout>!
    
    init(dataController: DataController, workout: Workout) {
        self.dataController = dataController
        self.workout = workout
        self.workoutExercises = workout.exercisesArray
    }
    
    func setupWorkoutController() {
        let fetchRequest = Workout.fetchRequest()
        let workoutPredicate = NSPredicate(format: "id == %@", workout.unwrappedId as CVarArg)
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = workoutPredicate
        
        workoutController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        do {
            workoutController.delegate = self
            try workoutController.performFetch()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }

    func deleteExercise(_ exercise: Exercise) {
        do {
            try dataController.deleteExerciseInWorkout(delete: exercise, in: workout)
            try dataController.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
