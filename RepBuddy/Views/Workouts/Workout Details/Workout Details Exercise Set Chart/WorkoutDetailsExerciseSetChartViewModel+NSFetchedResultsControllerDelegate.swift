//
//  WorkoutDetailsExerciseSetChartViewModel+NSFetchedResultsControllerDelegate.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/12/22.
//

import CoreData
import Foundation

extension WorkoutDetailsExerciseSetChartViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let updatedFetchedExercises = controller.fetchedObjects as? [Exercise],
           !updatedFetchedExercises.isEmpty {
            self.exercise = updatedFetchedExercises.first!
        }
    }
}
