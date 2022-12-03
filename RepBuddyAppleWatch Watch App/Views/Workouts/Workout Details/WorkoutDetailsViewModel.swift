//
//  WorkoutDetailsViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import CoreData
import Foundation

class WorkoutDetailsViewModel: NSObject, ObservableObject {
//    @Published var exercise: Exercise?
    @Published var workoutExercises = [Exercise]()

    let dataController: DataController
    let workout: Workout

    var workoutController: NSFetchedResultsController<Workout>!

    init(dataController: DataController, workout: Workout) {
        self.dataController = dataController
        self.workout = workout
        self.workoutExercises = workout.exercisesArray
    }

    func setupWorkoutController() {
        let fetchRequest = Workout.fetchRequest()
        let workoutPredicate = NSPredicate(format: "%K == %@", "id", workout.unwrappedId as CVarArg)
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = workoutPredicate

        workoutController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        do {
            try workoutController.performFetch()
        } catch {
            print("workout controller fetch error")
        }

        workoutController.delegate = self
    }

    func save() {
        guard dataController.moc.hasChanges else { return }

        do {
            try dataController.moc.save()
        } catch {
            print(error)
        }
    }
}
