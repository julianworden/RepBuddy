//
//  ExercisesViewGoalProgressViewModel+NSFetchedResultsControllerDelegate.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/14/22.
//

import CoreData
import Foundation
import SwiftUI

extension ExercisesViewGoalProgressViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedExercises = controller.fetchedObjects as? [Exercise],
           !fetchedExercises.isEmpty {
            self.exercise = fetchedExercises.first!
        }
    }
}
