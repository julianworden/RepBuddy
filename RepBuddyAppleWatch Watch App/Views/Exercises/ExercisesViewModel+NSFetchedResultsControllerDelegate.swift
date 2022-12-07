//
//  HomeViewModel+NSFetchedResultsControllerDelegate.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import CoreData
import Foundation

extension ExercisesViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedExercises = controller.fetchedObjects as? [Exercise] {
            self.exercises = fetchedExercises
        } else {
            viewState = .error(message: "Failed to fetch exercises")
        }

        exercises.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
    }
}
