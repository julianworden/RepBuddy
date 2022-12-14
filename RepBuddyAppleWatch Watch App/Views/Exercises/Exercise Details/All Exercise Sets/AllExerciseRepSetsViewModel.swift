//
//  AllExerciseRepSetsViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/13/22.
//

import CoreData
import Foundation

class AllExerciseRepSetsViewModel: NSObject, ObservableObject {
    @Published var workouts = [Workout]()
    @Published var exercise: Exercise

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""

    @Published var viewState = ViewState.displayingView {
        didSet {
            switch viewState {
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
    var workoutController: NSFetchedResultsController<Workout>!

    init(dataController: DataController, exercise: Exercise) {
        self.dataController = dataController
        self.exercise = exercise
    }

    func setupExerciseController() {
        let fetchRequest = Workout.fetchRequest()
        let predicate = NSPredicate(format: "exercises CONTAINS %@", exercise)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]

        workoutController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        workoutController.delegate = self

        do {
            try workoutController.performFetch()
            workouts = workoutController.fetchedObjects ?? []
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
