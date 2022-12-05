//
//  AddExerciseViewModel.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/2/22.
//

import Foundation

class AddExerciseViewModel: ObservableObject {
    @Published var allUserExercises = [Exercise]()
    @Published var dismissView = false

    let dataController: DataController
    let workout: Workout

    init(dataController: DataController, workout: Workout) {
        self.dataController = dataController
        self.workout = workout
    }

    func fetchAllUserExercises() {
        let fetchRequest = Exercise.fetchRequest()

        do {
            let allUserExercises = try dataController.moc.fetch(fetchRequest)
            self.allUserExercises = allUserExercises
        } catch {
            print(error)
        }
    }

    func exerciseSelected(_ exercise: Exercise) {
        workout.addToExercises(exercise)
        save()
    }

    func save() {
        guard dataController.moc.hasChanges else { return }

        do {
            try dataController.moc.save()
        } catch {
            print(error)
        }
    }
}
