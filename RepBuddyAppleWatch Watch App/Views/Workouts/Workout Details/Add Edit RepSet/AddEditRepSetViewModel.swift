//
//  AddEditRepSetViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import Foundation

class AddEditRepSetViewModel: ObservableObject {
    @Published var repCount = 5
    @Published var repSetWeight = 20

    let dataController: DataController
    let workout: Workout
    let exercise: Exercise
    var repSetToEdit: RepSet?

    var saveButtonText: String {
        repSetToEdit == nil ? "Create Set" : "Update Set"
    }
    
    init(
        dataController: DataController,
        workout: Workout,
        exercise: Exercise,
        repSetToEdit: RepSet? = nil
    ) {
        self.dataController = dataController
        self.workout = workout
        self.exercise = exercise
        self.repSetToEdit = repSetToEdit
        
        if let repSetToEdit {
            repCount = Int(repSetToEdit.reps)
        }
    }
    
    func confirmButtonTapped() {
        if repSetToEdit == nil {
            saveRepSet()
        } else {
            updateRepSet()
        }
    }
    
    func saveRepSet() {
        let repSet = RepSet(context: dataController.moc)

        repSet.number = Int16(exercise.repSetArray.count + 1)
        repSet.reps = Int16(repCount)
        repSet.weight = Int16(repSetWeight)
        repSet.exercise = exercise
        repSet.workout = workout
        
        save()
    }
    
    func updateRepSet() {
        guard let repSetToEdit else { return }
        
        repSetToEdit.reps = Int16(repCount)
        repSetToEdit.weight = Int16(repSetWeight)
        repSetToEdit.exercise = exercise

        save()
    }
    
    func deleteRepSet() {
        guard let repSetToEdit else { return }
        
        exercise.removeFromRepSet(repSetToEdit)
        dataController.moc.delete(repSetToEdit)
        
        save()
    }
    
    func save() {
        guard dataController.moc.hasChanges else { print("No changes detected for save"); return }
        
        do {
            try dataController.moc.save()
        } catch {
            print(error)
        }
    }
}
