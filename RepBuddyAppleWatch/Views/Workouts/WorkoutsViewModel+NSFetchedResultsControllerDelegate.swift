//
//  WorkoutsViewModel+NSFetchedResultsControllerDelegate.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import CoreData
import Foundation

extension WorkoutsViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedWorkouts = controller.fetchedObjects as? [Workout] {
            self.workouts = fetchedWorkouts.sorted { $0.unwrappedDate > $1.unwrappedDate }
        }

        workouts.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
    }
}
