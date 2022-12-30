//
//  WorkoutDetailsViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import CoreData
import Foundation

class WorkoutDetailsViewModel: NSObject, ObservableObject {
    @Published var workoutExercises = [Exercise]()
    @Published var dismissView = false

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""

    @Published var viewState = ViewState.dataLoaded {
        didSet {
            switch viewState {
            case .dataDeleted:
                dismissView = true

            case .error(let message):
                errorAlertText = message
                errorAlertIsShowing = true

            default:
                errorAlertText = "Unknown ViewState"
                errorAlertIsShowing = true
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
        let workoutPredicate = NSPredicate(format: "%K == %@", "id", workout.unwrappedId as CVarArg)
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = workoutPredicate

        workoutController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        workoutController.delegate = self

        do {
            try workoutController.performFetch()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
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
