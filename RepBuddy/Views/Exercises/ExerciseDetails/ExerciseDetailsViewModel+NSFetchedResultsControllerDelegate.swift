//
//  ExerciseDetailsViewModel+NSFetchedResultsControllerDelegate.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/12/22.
//

import CoreData
import Foundation

extension ExerciseDetailsViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let updatedExercises = controller.fetchedObjects as? [Exercise],
           !updatedExercises.isEmpty {
            self.exercise = updatedExercises.first!
        }
    }
}
