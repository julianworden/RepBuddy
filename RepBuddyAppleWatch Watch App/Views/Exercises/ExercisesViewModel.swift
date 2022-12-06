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

    @Published var viewState = ViewState.dataLoading
    
    let dataController: DataController
    var exercisesController: NSFetchedResultsController<Exercise>!

    var scrollDisabled: Bool {
        viewState != .dataLoaded
    }
    
    init(dataController: DataController) {
        self.dataController = dataController
        super.init()
        
        getExercises()
    }
    
    func getExercises() {
        let exercisesFetchRequest = NSFetchRequest<Exercise>(entityName: CoreDataConstants.Exercise)
        exercisesFetchRequest.sortDescriptors = []
        
        exercisesController = NSFetchedResultsController(
            fetchRequest: exercisesFetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        exercisesController.delegate = self

        do {
            try exercisesController.performFetch()
            exercises = exercisesController.fetchedObjects ?? []

            exercises.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
        } catch {
            print(error)
        }
    }
}
