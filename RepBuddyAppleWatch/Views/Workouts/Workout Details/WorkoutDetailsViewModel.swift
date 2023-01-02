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

    @Published var viewState = ViewState.displayingView {
        didSet {
            switch viewState {
            case .dataDeleted:
                dismissView = true

            case .error(let message):
                errorAlertText = message
                errorAlertIsShowing = true

            default:
                errorAlertText = "Invalid ViewState"
                errorAlertIsShowing = true
            }
        }
    }

    let dataController: DataController
    @Published var workout: Workout

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

        do {
            workoutController.delegate = self
            try workoutController.performFetch()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
