//
//  ExerciseDetailsViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import CoreData
import Foundation

class ExerciseDetailsViewModel: NSObject, ObservableObject {
    @Published var addEditExerciseSheetIsShowing = false
    @Published var dismissView = false

    @Published var viewState = ViewState.dataLoaded {
        didSet {
            viewState == .dataDeleted ? (dismissView = true) : nil
        }
    }

    let dataController: DataController
    let exercise: Exercise

    var exerciseController: NSFetchedResultsController<Exercise>!
    
    init(dataController: DataController, exercise: Exercise) {
        self.dataController = dataController
        self.exercise = exercise
    }

    func setupExerciseController() {
        let fetchRequest = Exercise.fetchRequest()
        let workoutPredicate = NSPredicate(format: "id == %@", exercise.unwrappedId as CVarArg)
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = workoutPredicate

        exerciseController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        exerciseController.delegate = self

        do {
            try exerciseController.performFetch()
        } catch {
            print("workout controller fetch error")
        }
    }
}
