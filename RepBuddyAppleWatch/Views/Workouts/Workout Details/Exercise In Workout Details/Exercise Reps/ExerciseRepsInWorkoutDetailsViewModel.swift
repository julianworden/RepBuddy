//
//  ExerciseRepsInWorkoutDetailsViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/5/22.
//

import CoreData
import Foundation

class ExerciseRepsInWorkoutDetailsViewModel: NSObject, ObservableObject {
    @Published var addEditRepSetSheetIsShowing = false

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""

    @Published var viewState = ViewState.dataLoaded {
        didSet {
            switch viewState {
            case .error(let message):
                errorAlertText = message
                errorAlertIsShowing = true

            default:
                errorAlertText = "Invalid ViewState"
                errorAlertIsShowing = true
            }
        }
    }

    @Published var repSets = [RepSet]()

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
        let fetchRequest = RepSet.fetchRequest()
        let workoutPredicate = NSPredicate(format: "workout == %@", workout)
        let exercisePredicate = NSPredicate(format: "exercise == %@", exercise)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [workoutPredicate, exercisePredicate])
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.predicate = compoundPredicate
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            repSets = try dataController.moc.fetch(fetchRequest)

            repSets.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }

    func repSetButtonTapped(_ repSet: RepSet) {
        repSetToEdit = repSet
        addEditRepSetSheetIsShowing.toggle()
    }
}
