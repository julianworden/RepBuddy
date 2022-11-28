//
//  WorkoutDetailsViewModel+NSFetchedResultsControllerDelegate.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import CoreData
import Foundation

extension WorkoutDetailsViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let updatedExercise = controller.fetchedObjects as? [Exercise] {
            self.exercise = updatedExercise[0]
        }
    }
}
