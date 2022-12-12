//
//  AddEditExerciseView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import SwiftUI

struct AddEditExerciseView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: AddEditExerciseViewModel
    
    init(dataController: DataController, exerciseToEdit: Exercise? = nil) {
        _viewModel = StateObject(wrappedValue: AddEditExerciseViewModel(dataController: dataController, exerciseToEdit: exerciseToEdit))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name (required)", text: $viewModel.exerciseName)
                
                Section("What's your goal?") {
                    Stepper("\(viewModel.exerciseWeightGoal)", value: $viewModel.exerciseWeightGoal)
                    
                    Picker("Unit of measurement", selection: $viewModel.exerciseWeightGoalUnit) {
                        ForEach(WeightUnit.allCases) {
                            Text($0.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.inline)
                }
                .labelsHidden()
                
                Section {
                    Button("Save") {
                        viewModel.saveExercise()
                    }
                    .foregroundColor(.blue)

                    if viewModel.exerciseToEdit != nil {
                        Button("Delete Exercise", role: .destructive) {
                            viewModel.deleteExerciseAlertIsShowing.toggle()
                        }
                        .alert("Are You Sure?", isPresented: $viewModel.deleteExerciseAlertIsShowing) {
                            Button("Yes", role: .destructive) { viewModel.deleteExercise(); dismiss() }
                        } message: {
                            Text(AlertConstants.deleteExerciseMessage)
                        }
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

struct AddEditExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddEditExerciseView(dataController: DataController.preview)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {

                        }
                    }
                }
        }
    }
}
