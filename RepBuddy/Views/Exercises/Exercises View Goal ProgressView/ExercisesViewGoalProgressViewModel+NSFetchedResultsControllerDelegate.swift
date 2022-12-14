//
//  ExercisesViewGoalProgressViewModel+NSFetchedResultsControllerDelegate.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/14/22.
//

import CoreData
import Foundation

extension ExercisesViewGoalProgressViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedExercises = controller.fetchedObjects as? [Exercise],
           !fetchedExercises.isEmpty {
            self.exercise = fetchedExercises.first!
        } else {
            viewState = .error(message: "Failed to fetch updated Exercise information. Please restart Rep Buddy and try again.")
        }
    }
}
