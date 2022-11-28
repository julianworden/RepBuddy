//
//  WorkoutDetailsViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import CoreData
import Foundation

class WorkoutDetailsViewModel: NSObject, ObservableObject {
    @Published var addSetSheetIsShowing = false
    
    let dataController: DataController
    let workout: Workout
    @Published var exercise: Exercise?
    @Published var workoutExercises = [Exercise]()
    var repSetToEdit: RepSet?
    
    var exerciseController: NSFetchedResultsController<Exercise>!
    
    init(dataController: DataController, workout: Workout) {
        self.dataController = dataController
        self.workout = workout
        self.workoutExercises = workout.exercisesArray
    }
    
    func setupExerciseController() {
        let exerciseFetchRequest = NSFetchRequest<Exercise>(entityName: CoreDataConstants.Exercise)
        let exercisePredicate = NSPredicate(format: "%K == %@", "id", exercise!.id! as CVarArg)
        exerciseFetchRequest.sortDescriptors = []
        exerciseFetchRequest.predicate = exercisePredicate
        
        exerciseController = NSFetchedResultsController(
            fetchRequest: exerciseFetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        exerciseController.delegate = self
    }
    
    func addSetButtonTapped(for exercise: Exercise) {
        self.exercise = exercise
        setupExerciseController()
        addSetSheetIsShowing.toggle()
    }
    
    func editSetButtonTapped(for repSet: RepSet, in exercise: Exercise) {
        repSetToEdit = repSet
        self.exercise = exercise
        addSetSheetIsShowing.toggle()
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
    
    func save() {
        guard dataController.moc.hasChanges else { return }
        
        do {
            try dataController.moc.save()
        } catch {
            print(error)
        }
    }
}
