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

    let workout: Workout
    let dataController: DataController
    var exerciseController: NSFetchedResultsController<Exercise>!

    init(dataController: DataController, exercise: Exercise, workout: Workout) {
        self.dataController = dataController
        self.exercise = exercise
        self.workout = workout
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

    func fetchRepSets(in exercise: Exercise, and workout: Workout) -> [RepSet] {
        let fetchRequest = RepSet.fetchRequest()
        let workoutPredicate = NSPredicate(format: "workout == %@", workout)
        let exercisePredicate = NSPredicate(format: "exercise == %@", exercise)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [workoutPredicate, exercisePredicate])
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.predicate = compoundPredicate
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let fetchedRepSets = try dataController.moc.fetch(fetchRequest)
            return fetchedRepSets
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
            return []
        }
    }
}
