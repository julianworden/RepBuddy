//
//  WorkoutsViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import CoreData
import Foundation

final class WorkoutsViewModel: NSObject, ObservableObject {
    @Published var workouts = [Workout]()
    @Published var addWorkoutSheetIsShowing = false

    @Published var viewState = ViewState.dataLoading

    var scrollDisabled: Bool {
        viewState != .dataLoaded
    }
    
    let dataController: DataController

    var workoutsController: NSFetchedResultsController<Workout>!

    init(dataController: DataController) {
        self.dataController = dataController
    }

    func setupWorkoutsController() {
        let fetchRequest = Workout.fetchRequest()
        fetchRequest.sortDescriptors = []

        workoutsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        do {
            workoutsController.delegate = self
            try workoutsController.performFetch()
            workouts = workoutsController.fetchedObjects ?? []

            workouts.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
        } catch {
            viewState = .error(message: "Failed to fetch workouts")
        }
    }

    func addWorkoutButtonTapped() {
        addWorkoutSheetIsShowing.toggle()
    }

    func addWorkoutSheetDismissed() {
        viewState = .dataLoading

        workouts.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
    }
}
