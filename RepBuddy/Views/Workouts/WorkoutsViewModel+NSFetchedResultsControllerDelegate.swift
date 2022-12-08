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
        if let workouts = controller.fetchedObjects as? [Workout] {
            self.workouts = workouts
        }

        workouts.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
    }
}
