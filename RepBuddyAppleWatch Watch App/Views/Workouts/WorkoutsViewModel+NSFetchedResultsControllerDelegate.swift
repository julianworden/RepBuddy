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
        viewState = .dataLoading

        if let fetchedWorkouts = controller.fetchedObjects as? [Workout] {
            self.workouts = fetchedWorkouts
        }

        self.workouts.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
    }
}
