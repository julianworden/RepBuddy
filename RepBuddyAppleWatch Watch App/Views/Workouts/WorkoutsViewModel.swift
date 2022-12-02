//
//  WorkoutsViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import CoreData
import Foundation

class WorkoutsViewModel: NSObject, ObservableObject {
    @Published var workouts = [Workout]()
    @Published var addWorkoutSheetIsShowing = false

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
        } catch {
            print("Error performing fetch: \(error)")
        }
    }

    func addWorkoutButtonTapped() {
        addWorkoutSheetIsShowing.toggle()
    }
}
