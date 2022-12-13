//
//  WorkoutDetailsExerciseSetChartViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/12/22.
//

import CoreData
import Foundation

class WorkoutDetailsExerciseSetChartViewModel: NSObject, ObservableObject {
    @Published var exercise: Exercise

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""

    @Published var viewState = ViewState.displayingView {
        didSet {
            switch viewState {
            case .error(let message):
                errorAlertIsShowing.toggle()
                errorAlertText = message

            default:
                errorAlertIsShowing.toggle()
                errorAlertText = "Invalid ViewState"
            }
        }
    }

    let dataController: DataController
    var exerciseController: NSFetchedResultsController<Exercise>!

    init(dataController: DataController, exercise: Exercise) {
        self.dataController = dataController
        self.exercise = exercise
    }

    func setupExerciseController() {
        let fetchRequest = Exercise.fetchRequest()
        let exercisePredicate = NSPredicate(format: "id == %@", exercise.unwrappedId as CVarArg)
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = exercisePredicate

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
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
