//
//  ExerciseInWorkoutDetailsViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/2/22.
//

import CoreData
import Foundation

class ExerciseInWorkoutDetailsViewModel: NSObject, ObservableObject {
    @Published var exercise: Exercise
    let workout: Workout
    let dataController: DataController

    @Published var addEditRepSetSheetIsShowing = false
    var repSetToEdit: RepSet?

    var exerciseController: NSFetchedResultsController<Exercise>!

    init(dataController: DataController, exercise: Exercise, workout: Workout) {
        self.exercise = exercise
        self.workout = workout
        self.dataController = dataController
    }

    func fetchRepSet(in exercise: Exercise, and workout: Workout) -> [RepSet] {
        let fetchRequest = RepSet.fetchRequest()
        let workoutPredicate = NSPredicate(format: "workout == %@", workout)
        let exercisePredicate = NSPredicate(format: "exercise == %@", exercise)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [workoutPredicate, exercisePredicate])
        fetchRequest.predicate = compoundPredicate

        do {
            let fetchedRepSets = try dataController.moc.fetch(fetchRequest)
            return fetchedRepSets
        } catch {
            print(error)
        }

        return []
    }

    func setupExerciseController() {
        let fetchRequest = Exercise.fetchRequest()
        let exercisePredicate = NSPredicate(format: "%K == %@", "id", exercise.unwrappedId as CVarArg)
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = exercisePredicate

        exerciseController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        exerciseController.delegate = self
    }

    func deleteExercise() {
        let fetchRequest = RepSet.fetchRequest()
        let workoutPredicate = NSPredicate(format: "workout == %@", workout)
        let exercisePredicate = NSPredicate(format: "exercise == %@", exercise)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [workoutPredicate, exercisePredicate])
        fetchRequest.predicate = compoundPredicate
        fetchRequest.sortDescriptors = []

        do {
            let exerciseRepsInWorkout = try dataController.moc.fetch(fetchRequest)

            for repSet in exerciseRepsInWorkout {
                exercise.removeFromRepSet(repSet)
            }

            workout.removeFromExercises(exercise)

            save()
        } catch {
            print(error)
        }
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
