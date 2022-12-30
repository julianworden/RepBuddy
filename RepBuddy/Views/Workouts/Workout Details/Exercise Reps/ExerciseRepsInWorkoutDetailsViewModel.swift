//
//  ExerciseRepsInWorkoutDetailsViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/8/22.
//

import CoreData
import Foundation

class ExerciseRepsInWorkoutDetailsViewModel: NSObject, ObservableObject {
    @Published var repSets = [RepSet]()

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""

    @Published var addRepSetSheetIsShowing = false
    @Published var editRepSetSheetIsShowing = false

    @Published var viewState = ViewState.dataLoaded {
        didSet {
            switch viewState {
                
            case .error(let message):
                errorAlertText = message
                errorAlertIsShowing = true

            default:
                if viewState != .dataLoaded && viewState != .dataNotFound {
                    errorAlertText = "Invalid ViewState"
                    errorAlertIsShowing = true
                }
            }
        }
    }

    let dataController: DataController
    let workout: Workout
    let exercise: Exercise
    var repSetToEdit: RepSet?

    var exerciseController: NSFetchedResultsController<Exercise>!

    init(
        dataController: DataController,
        workout: Workout,
        exercise: Exercise,
        repSets: [RepSet]
    ) {
        self.dataController = dataController
        self.workout = workout
        self.exercise = exercise
        self.repSets = repSets
    }

    func setUpExerciseController() {
        let fetchRequest = Exercise.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", exercise.unwrappedId as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = []

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

    func fetchRepSets(in exercise: Exercise, and workout: Workout) {
        do {
            repSets = try dataController.getRepSets(in: exercise, and: workout)
            repSets.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }

    func deleteRepSet(in exercise: Exercise, at indexSet: IndexSet) {
        do {
            for index in indexSet {
                dataController.deleteRepSet(exercise.repSetsArray[index])
            }

            try dataController.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
