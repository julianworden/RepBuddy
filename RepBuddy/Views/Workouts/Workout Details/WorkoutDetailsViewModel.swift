//
//  WorkoutDetailsViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import CoreData
import Foundation
import SwiftUI

class WorkoutDetailsViewModel: NSObject, ObservableObject {
    @Published var exercise: Exercise?
    @Published var workoutExercises = [Exercise]()

    let dataController: DataController
    let workout: Workout
    
    var exerciseController: NSFetchedResultsController<Exercise>!
    var workoutController: NSFetchedResultsController<Workout>!
    
    init(dataController: DataController, workout: Workout) {
        self.dataController = dataController
        self.workout = workout
        self.workoutExercises = workout.exercisesArray
    }
    
    func setupExerciseController(with exercise: Exercise) {
        self.exercise = exercise
        
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

    func deleteExercise(_ exercise: Exercise) {
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
    
    func deleteRepSet(in exercise: Exercise, at indexSet: IndexSet) {
        self.exercise = exercise
        
        for index in indexSet {
            let repSetToDelete = exercise.repSetArray[index]
            self.exercise!.removeFromRepSet(repSetToDelete)
            dataController.moc.delete(repSetToDelete)
        }
        
        save()
    }

    func addExerciseObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(newExerciseSelected(_:)),
            name: .exerciseSelected,
            object: nil
        )
    }

    @objc func newExerciseSelected(_ notification: Notification) {
        if let newExercise = notification.userInfo?[NotificationConstants.exercise] as? Exercise {
            workoutExercises.append(newExercise)
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
