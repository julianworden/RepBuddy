//
//  ExerciseInWorkoutDetailsViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/2/22.
//

import CoreData
import Foundation

extension ExerciseInWorkoutDetailsViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        fetchRepSets(in: exercise, and: workout)
    }
}
