//
//  HomeViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import CoreData
import Foundation

class ExercisesViewModel: NSObject, ObservableObject {
    @Published var exercises = [Exercise]()
    @Published var addEditExerciseSheetIsShowing = false
    
    let dataController: DataController
    var exercisesController: NSFetchedResultsController<Exercise>!
    
    init(dataController: DataController) {
        self.dataController = dataController
        super.init()
        
        setupExercisesController()
        getExercises()
    }
    
    func setupExercisesController() {
        let exercisesFetchRequest = NSFetchRequest<Exercise>(entityName: CoreDataConstants.Exercise)
        exercisesFetchRequest.sortDescriptors = []
        
        exercisesController = NSFetchedResultsController(
            fetchRequest: exercisesFetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        exercisesController.delegate = self
    }
    
    func getExercises() {
        do {
            try exercisesController.performFetch()
            exercises = exercisesController.fetchedObjects ?? []
        } catch {
            print(error)
        }
    }
    
    func deleteExercise(at indexSet: IndexSet) {
        for index in indexSet {
            dataController.moc.delete(exercises[index])
        }
        
        do {
            try dataController.moc.save()
        } catch {
            print(error)
        }
    }
}
