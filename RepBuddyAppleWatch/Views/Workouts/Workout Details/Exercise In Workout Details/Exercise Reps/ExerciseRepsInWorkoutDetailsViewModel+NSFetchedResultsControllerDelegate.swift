//
//  ExerciseRepsInWorkoutDetailsViewModel+NSFetchedResultsControllerDelegate.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/5/22.
//

import CoreData
import Foundation

extension ExerciseRepsInWorkoutDetailsViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        fetchRepSet(in: exercise, and: workout)
    }
}
