//
//  ExerciseRepsViewModel+NSFetchedResultsControllerDelegate.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/8/22.
//

import CoreData
import Foundation

extension ExerciseRepsViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        fetchRepSet(in: exercise, and: workout)
    }
}
