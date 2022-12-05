//
//  AddEditWorkoutView.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import SwiftUI

struct AddEditWorkoutView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel: AddEditWorkoutViewModel

    init(dataController: DataController, workoutToEdit: Workout? = nil) {
        _viewModel = StateObject(wrappedValue: AddEditWorkoutViewModel(dataController: dataController, workoutToEdit: workoutToEdit))
    }

    var body: some View {
        Form {
            Picker("Type", selection: $viewModel.workoutType) {
                ForEach(WorkoutType.allCases) {
                    Text($0.rawValue)
                }
            }

            Button {
                viewModel.saveButtonTapped()
            } label: {
                Text("Save")
            }
            .foregroundColor(.blue)

            if viewModel.workoutToEdit != nil {
                Button("Delete Workout") {
                    viewModel.deleteWorkout()
                    dismiss()
                }
                .foregroundColor(.red)
            }
        }
    }
}

struct AddEditWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditWorkoutView(dataController: DataController.preview)
    }
}
