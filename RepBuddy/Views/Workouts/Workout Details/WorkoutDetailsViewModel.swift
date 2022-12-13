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
            try workoutController.performFetch()
        } catch {
            print("workout controller fetch error")
        }

        workoutController.delegate = self
    }

    func deleteExercise(_ exercise: Exercise) {
        let fetchRequest = RepSet.fetchRequest()
        let workoutPredicate = NSPredicate(format: "workout == %@", workout)
        let exercisePredicate = NSPredicate(format: "exercise == %@", exercise)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [workoutPredicate, exercisePredicate])
        fetchRequest.predicate = compoundPredicate

        do {
            let exerciseRepsInWorkout = try dataController.moc.fetch(fetchRequest)

            for repSet in exerciseRepsInWorkout {
                exercise.removeFromRepSet(repSet)
            }

            workout.removeFromExercises(exercise)

            save()
        } catch {
            print(error)
        }
    }

    func fetchRepSet(in exercise: Exercise, and workout: Workout) -> [RepSet] {
        let fetchRequest = RepSet.fetchRequest()
        let workoutPredicate = NSPredicate(format: "workout == %@", workout)
        let exercisePredicate = NSPredicate(format: "exercise == %@", exercise)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [workoutPredicate, exercisePredicate])
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.predicate = compoundPredicate
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let fetchedRepSets = try dataController.moc.fetch(fetchRequest)
            return fetchedRepSets
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }

        return []
    }

    func save() {
        guard dataController.moc.hasChanges else { print("moc has no changes, save not performed"); return }

        do {
            try dataController.moc.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
