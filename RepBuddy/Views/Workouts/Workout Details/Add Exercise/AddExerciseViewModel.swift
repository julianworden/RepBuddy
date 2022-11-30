//
//  AddExerciseViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/29/22.
//

import CoreData
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
        NotificationCenter.default.post(name: .exerciseSelected, object: nil, userInfo: [NotificationConstants.exercise: exercise])
        workout.addToExercises(exercise)
        save()

        dismissView = true
    }

    func save() {
        do {
            try dataController.moc.save()
        } catch {
            print(error)
        }
    }
}
