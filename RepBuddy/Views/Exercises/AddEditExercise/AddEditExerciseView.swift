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
    
    init(dataController: DataController) {
        _viewModel = StateObject(wrappedValue: AddEditExerciseViewModel(dataController: dataController))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name (required)", text: $viewModel.exerciseName)
                
                Section("What's your goal?") {
                    TextField("Weight goal", value: $viewModel.exerciseWeightGoal, format: .number)
                    Picker("Unit of measurement", selection: $viewModel.exerciseWeightGoalUnit) {
                        ForEach(WeightUnit.allCases) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Button("Save") {
                        viewModel.saveExercise()
                    }
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
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

struct AddEditExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditExerciseView(dataController: DataController.preview)
    }
}
