//
//  AddEditWorkoutViewModel.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

final class AddEditWorkoutViewModel: ObservableObject {
    @Published var workoutDate = Date.now
    @Published var workoutType = WorkoutType.arms

    @Published var errorAlertIsShowing = false
    @Published var errorAlertText = ""
    @Published var deleteWorkoutAlertIsShowing = false
    @Published var dismissView = false

    @Published var viewState = ViewState.displayingView {
        didSet {
            switch viewState {
            case .error(let message):
                errorAlertText = message
                errorAlertIsShowing.toggle()

            default:
                errorAlertText = "Invalid ViewState"
                errorAlertIsShowing.toggle()
            }
        }
    }
    
    var workoutToEdit: Workout?
    
    var navigationTitle: String {
        workoutToEdit == nil ? "Add Workout" : "Edit Workout"
    }
    
    var saveButtonText: String {
        workoutToEdit == nil ? "Save Workout" : "Update Workout"
    }

    var updatedWorkoutDateForRepSets: Date? {
        guard let workoutToEdit else { return nil }

        let updatedDateComponents = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: workoutDate
        )
        let workoutToEditDateComponents = Calendar.current.dateComponents(
            [.hour, .minute, .second],
            from: workoutToEdit.unwrappedDate
        )
        let editedWorkoutDateComponents = DateComponents(
            year: updatedDateComponents.year,
            month: updatedDateComponents.month,
            day: updatedDateComponents.day,
            hour: workoutToEditDateComponents.hour,
            minute: workoutToEditDateComponents.minute,
            second: workoutToEditDateComponents.second
        )
        let updatedWorkoutDateForRepsets = Calendar.current.date(from: editedWorkoutDateComponents)

        return updatedWorkoutDateForRepsets
    }
    
    let dataController: DataController
    
    init(dataController: DataController, workoutToEdit: Workout? = nil) {
        self.dataController = dataController
        self.workoutToEdit = workoutToEdit
        
        if let workoutToEdit {
            workoutDate = workoutToEdit.unwrappedDate
            workoutType = WorkoutType(rawValue: workoutToEdit.unwrappedType)!
        }
    }
    
    func saveButtonTapped() {
        if workoutToEdit == nil {
            saveWorkout()
        } else {
            updateWorkout()
        }
        
        dismissView.toggle()
    }
    
    func saveWorkout() {
        let newWorkout = Workout(context: dataController.moc)
        newWorkout.id = UUID()
        newWorkout.date = workoutDate
        newWorkout.type = workoutType.rawValue

        save()
    }
    
    func updateWorkout() {
        guard let workoutToEdit else { return }
        
        workoutToEdit.date = workoutDate
        workoutToEdit.type = workoutType.rawValue

        workoutToEdit.repSetsArray.forEach { repSet in
            let updatedRepSetDate = createUpdatedRepSetDate(for: repSet)
            repSet.date = updatedRepSetDate
        }

        save()
    }

    /// Updates the date property for a RepSet object. Called on each RepSet object in a Workout's repSetsArray property
    /// whenever a Workout update takes place. This is done so that, if a Workout's date changes, its RepSets'
    /// date properties change with it.
    ///
    /// When this method is run, the only part of the given RepSet that is modified is its year, month, and day. Its hour, minute
    /// and hour info is retained. This is done so that the order of the RepSets within the Workout is preserved, and it works
    /// because the Workout time is not modifiable.
    /// - Parameter repSet: The RepSet to be edited.
    /// - Returns: The updated Date for the given RepSet.
    func createUpdatedRepSetDate(for repSet: RepSet) -> Date? {
        let updatedRepSetDateComponents = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: workoutDate
        )
        let repSetDateComponents = Calendar.current.dateComponents(
            [.hour, .minute, .second],
            from: repSet.unwrappedDate
        )
        let fullUpdatedRepSetDateComponents = DateComponents(
            year: updatedRepSetDateComponents.year,
            month: updatedRepSetDateComponents.month,
            day: updatedRepSetDateComponents.day,
            hour: repSetDateComponents.hour,
            minute: repSetDateComponents.minute,
            second: repSetDateComponents.second
        )
        let fullUpdatedRepSetDate = Calendar.current.date(from: fullUpdatedRepSetDateComponents)

        return fullUpdatedRepSetDate
    }
    
    func save() {
        guard dataController.moc.hasChanges else { print("moc has no changes, save not performed"); return }

        do {
            try dataController.moc.save()
        } catch {
            viewState = .error(message: UnknownError.coreData(systemError: error.localizedDescription).localizedDescription)
        }
    }

    func deleteWorkout() {
        guard let workoutToEdit else { return }

        dataController.moc.delete(workoutToEdit)
        save()

        dismissView.toggle()
    }
}
