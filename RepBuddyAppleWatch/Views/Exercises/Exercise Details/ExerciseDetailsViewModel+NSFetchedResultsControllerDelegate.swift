//
//  ExerciseDetailsViewModel+NSFetchedResultsControllerDelegate.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/6/22.
//

import CoreData
import Foundation

extension ExerciseDetailsViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let updatedExercises = controller.fetchedObjects as? [Exercise],
           !updatedExercises.isEmpty {
            self.exercise = updatedExercises.first!
        } else {
            viewState = .dataDeleted
        }
    }
}
