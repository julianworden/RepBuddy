//
//  AddExerciseToWorkoutViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/29/22.
//

import CoreData
import Foundation

class AddExerciseToWorkoutViewModel: ObservableObject {
    @Published var allUserExercises = [Exercise]()
    @Published var dismissView = false

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""

    @Published var viewState = ViewState.dataLoading {
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

    init(dataController: DataController, workout: Workout) {
        self.dataController = dataController
        self.workout = workout
    }

    func exerciseIsNotSelectable(_ exercise: Exercise) -> Bool {
        return workout.exercisesArray.contains(exercise)
    }

    func fetchAllUserExercises() {
        let fetchRequest = Exercise.fetchRequest()

        do {
            let allUserExercises = try dataController.moc.fetch(fetchRequest)
            self.allUserExercises = allUserExercises

            self.allUserExercises.isEmpty ? (viewState = .dataNotFound) : (viewState = .dataLoaded)
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }

    func exerciseSelected(_ exercise: Exercise) {
        NotificationCenter.default.post(name: .exerciseSelected, object: nil, userInfo: [NotificationConstants.exercise: exercise])
        workout.addToExercises(exercise)
        save()

        dismissView = true
    }

    func save() {
        guard dataController.moc.hasChanges else { print("moc has no changes, save not performed"); return }

        do {
            try dataController.moc.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }
}
