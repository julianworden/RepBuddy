//
//  ExerciseRepsViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/8/22.
//

import CoreData
import Foundation

class ExerciseRepsViewModel: NSObject, ObservableObject {
    @Published var repSets = [RepSet]()

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""
    @Published var dismissView = false

    @Published var addRepSetSheetIsShowing = false
    @Published var editRepSetSheetIsShowing = false

    @Published var viewState = ViewState.dataLoaded {
        didSet {
            switch viewState {
            case .dataDeleted:
                dismissView = true

            case .error(let message):
                errorAlertText = message
                errorAlertIsShowing = true

            default:
                errorAlertText = "Unknown ViewState"
                errorAlertIsShowing = true
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

    func fetchRepSet(in exercise: Exercise, and workout: Workout) {
        let fetchRequest = RepSet.fetchRequest()
        let workoutPredicate = NSPredicate(format: "workout == %@", workout)
        let exercisePredicate = NSPredicate(format: "exercise == %@", exercise)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [workoutPredicate, exercisePredicate])
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.predicate = compoundPredicate
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            repSets = try dataController.moc.fetch(fetchRequest)

            repSets.isEmpty ? (viewState = .dataDeleted) : (viewState = .dataLoaded)
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }

    func deleteRepSet(in exercise: Exercise, at indexSet: IndexSet) {
        for index in indexSet {
            let repSetToDelete = exercise.repSetArray[index]
            dataController.moc.delete(repSetToDelete)
        }

        save()
    }

    func save() {
        guard dataController.moc.hasChanges else { print("No changes detected for save"); return }

        do {
            try dataController.moc.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
