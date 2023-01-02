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

    @Published var viewState = ViewState.dataLoading {
        didSet {
            switch viewState {
            case .error(let message):
                errorAlertIsShowing.toggle()
                errorAlertText = message

            default:
                if viewState != .dataLoaded && viewState != .dataNotFound {
                    errorAlertText = "Invalid ViewState"
                    errorAlertIsShowing.toggle()
                }
            }
        }
    }

    let dataController: DataController
    var workoutsController: NSFetchedResultsController<Workout>!

    init(dataController: DataController, exercise: Exercise) {
        self.dataController = dataController
        self.exercise = exercise
    }

    func setupWorkoutsController() {
        let fetchRequest = Workout.fetchRequest()
        let predicate = NSPredicate(format: "exercises CONTAINS %@", exercise)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]

        workoutsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        workoutsController.delegate = self
    }

    func getWorkouts() {
        do {
            try workoutsController.performFetch()
            // TODO: Add a Unit Test to check if these are sorted properly
            workouts = workoutsController.fetchedObjects?.sorted { $0.unwrappedDate > $1.unwrappedDate } ?? []
            workouts.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }

    func getRepSets(in exercise: Exercise, and workout: Workout) -> [RepSet] {
        do {
            return try dataController.getRepSets(in: exercise, and: workout)
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
            return []
        }
    }
}
