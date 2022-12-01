//
//  ContentViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import CoreData
import Foundation

class ContentViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    @Published var exercises = [Exercise]()

    let dataController: DataController

    var exercisesController: NSFetchedResultsController<Exercise>!

    init(dataController: DataController) {
        self.dataController = dataController
    }

    func setupExercisesController() {
        let fetchRequest = Exercise.fetchRequest()
        fetchRequest.sortDescriptors = []

        exercisesController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        do {
            exercisesController.delegate = self
            try exercisesController.performFetch()
            exercises = exercisesController.fetchedObjects ?? []
        } catch {
            print("Error performing fetch: \(error)")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedExercises = controller.fetchedObjects as? [Exercise] {
            self.exercises = fetchedExercises
        }
    }
}
