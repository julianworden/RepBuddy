//
//  WorkoutsViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import CoreData
import Foundation

final class WorkoutsViewModel: NSObject, ObservableObject {
    @Published var workouts = [Workout]()
    @Published var addEditWorkoutSheetIsShowing = false
    
    let dataController: DataController
    var workoutsController: NSFetchedResultsController<Workout>!
    
    init(dataController: DataController) {
        self.dataController = dataController
        super.init()
        
        setupWorkoutsController()
        getWorkouts()
    }
    
    func setupWorkoutsController() {
        let workoutsFetchRequest = NSFetchRequest<Workout>(entityName: CoreDataConstants.Workout)
        workoutsFetchRequest.sortDescriptors = []
        
        workoutsController = NSFetchedResultsController(
            fetchRequest: workoutsFetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        workoutsController.delegate = self
    }
    
    func getWorkouts() {
        do {
            try workoutsController.performFetch()
            workouts = workoutsController.fetchedObjects ?? []
        } catch {
            print(error)
        }
    }
    
    func deleteWorkout(at indexSet: IndexSet) {
        for index in indexSet {
            dataController.moc.delete(workouts[index])
        }
        
        do {
            try dataController.moc.save()
        } catch {
            print(error)
        }
    }
}
