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
            exercises = fetchedExercises.sorted { $0.unwrappedName < $1.unwrappedName }
        }

        exercises.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
    }
}
