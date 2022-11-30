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
        if let updatedFetchedExercises = controller.fetchedObjects as? [Exercise],
           !updatedFetchedExercises.isEmpty {
            self.exercise = updatedFetchedExercises.first!
        } else if let updatedFetchedWorkouts = controller.fetchedObjects as? [Workout],
                  !updatedFetchedWorkouts.isEmpty {
            self.workoutExercises = updatedFetchedWorkouts.first!.exercisesArray
        }
    }
}
