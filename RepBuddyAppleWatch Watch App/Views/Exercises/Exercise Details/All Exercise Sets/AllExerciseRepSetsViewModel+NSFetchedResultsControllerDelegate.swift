//
//  AllExerciseRepSetsViewModel+NSFetchedResultsControllerDelegate.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/13/22.
//

import CoreData
import Foundation

extension AllExerciseRepSetsViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let updatedWorkouts = controller.fetchedObjects as? [Workout] {
            self.workouts = updatedWorkouts
        } else {
            viewState = .error(message: "Failed to fetch updated workouts. Please restart RepBuddy and try again.")
        }
    }
}
