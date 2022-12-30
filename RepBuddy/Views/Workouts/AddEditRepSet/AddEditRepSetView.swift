//
//  AddEditRepSetView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import SwiftUI

struct AddEditRepSetView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: AddEditRepSetViewModel
    
    init(
        dataController: DataController,
        workout: Workout,
        exercise: Exercise,
        repSetToEdit: RepSet? = nil
    ) {
        _viewModel = StateObject(
            wrappedValue: AddEditRepSetViewModel(
                dataController: dataController,
                workout: workout,
                exercise: exercise,
                repSetToEdit: repSetToEdit
            )
        )
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("How many reps?") {
                    TextField("Rep count", text: $viewModel.repSetCount)
                }

                Section("How heavy? (\(viewModel.exercise.unwrappedGoalWeightUnit))") {
                    TextField("Weight", text: $viewModel.repSetWeight)
                }

                Section {
                    Button(viewModel.saveButtonText) {
                        viewModel.confirmButtonTapped()
                    }
                    
                    if viewModel.repSetToEdit != nil {
                        Button("Delete Set", role: .destructive) {
                            viewModel.deleteRepSetAlertIsShowing.toggle()
                        }
                        .alert("Are You Sure?", isPresented: $viewModel.deleteRepSetAlertIsShowing) {
                            Button("Cancel", role: .cancel) { }
                            Button("Yes", role: .destructive) { viewModel.deleteRepSet() }
                        } message: {
                            Text(AlertConstants.deleteRepSetMessage)
                        }
                    }
                }
            }
            .keyboardType(.numberPad)
            .navigationTitle(viewModel.navigationBarTitleText)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        viewModel.dismissView.toggle()
                    }
                }
            }
            .alert(
                "Error",
                isPresented: $viewModel.errorAlertIsShowing,
                actions: {
                    Button("OK") { }
                },
                message: {
                    Text(viewModel.errorAlertText)
                }
            )
            .onChange(of: viewModel.dismissView) { _ in
                dismiss()
            }
        }
    }
}

struct AddEditRepSetView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditRepSetView(dataController: DataController.preview, workout: Workout.example, exercise: Exercise.example)
    }
}
