//
//  ExerciseRepsInWorkoutDetailsViewModel+NSFetchedResultsControllerDelegate.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/8/22.
//

import CoreData
import Foundation

extension ExerciseRepsInWorkoutDetailsViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        fetchRepSet(in: exercise, and: workout)
    }
}
