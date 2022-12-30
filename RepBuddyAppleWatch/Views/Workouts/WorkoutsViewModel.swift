//
//  WorkoutsViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import CoreData
import Foundation

final class WorkoutsViewModel: NSObject, ObservableObject {
    @Published var workouts = [Workout]()
    @Published var addWorkoutSheetIsShowing = false

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""

    @Published var viewState = ViewState.dataLoading {
        didSet {
            switch viewState {
            case .error(let message):
                errorAlertText = message
                errorAlertIsShowing.toggle()

            default:
                if viewState != .dataLoaded && viewState != .dataNotFound {
                    errorAlertText = "Invalid ViewState"
                    errorAlertIsShowing.toggle()
                }
            }
        }
    }

    var scrollDisabled: Bool {
        viewState != .dataLoaded
    }
    
    let dataController: DataController

    var workoutsController: NSFetchedResultsController<Workout>!

    init(dataController: DataController) {
        self.dataController = dataController
        super.init()

        setupWorkoutsController()
    }

    func setupWorkoutsController() {
        let fetchRequest = Workout.fetchRequest()
        fetchRequest.sortDescriptors = []

        workoutsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: dataController.moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        do {
            workoutsController.delegate = self
            try workoutsController.performFetch()
            workouts = workoutsController.fetchedObjects ?? []

            workouts.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }

    func addWorkoutButtonTapped() {
        addWorkoutSheetIsShowing.toggle()
    }

    func addWorkoutSheetDismissed() {
        viewState = .dataLoading

        workouts.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
    }
}
