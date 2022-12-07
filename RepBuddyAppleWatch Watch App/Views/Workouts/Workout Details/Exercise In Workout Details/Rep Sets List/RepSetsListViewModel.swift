//
//  RepSetsListViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/5/22.
//

import CoreData
import Foundation

class RepSetsListViewModel: NSObject, ObservableObject {
    @Published var addEditRepSetSheetIsShowing = false
    @Published var dismissView = false
    @Published var viewState = ViewState.dataLoading {
        didSet {
            viewState == .dataDeleted ? (dismissView = true) : nil
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
            print(error)
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
            print(error)
        }
    }

    func repSetButtonTapped(_ repSet: RepSet) {
        repSetToEdit = repSet
        addEditRepSetSheetIsShowing.toggle()
    }
}
