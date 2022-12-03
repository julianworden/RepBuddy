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
                TextField("Name", text: $viewModel.exerciseName)
                
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

                Section("What muscles are you targeting?") {
                    VStack(alignment: .leading) {
                        HStack {
                            Toggle("Calves", isOn: $viewModel.calvesIsSelected)
                            Toggle("Biceps", isOn: $viewModel.bicepsIsSelected)
                            Toggle("Triceps", isOn: $viewModel.tricepsIsSelected)
                        }
                        
                        HStack {
                            Toggle("Pectoralis", isOn: $viewModel.pectoralisIsSelected)
                            Toggle("Deltoid", isOn: $viewModel.deltoidIsSelected)
                            Toggle("Trapezius", isOn: $viewModel.trapeziusIsSelected)
                        }
                        
                        HStack {
                            Toggle("Abs", isOn: $viewModel.abdomenIsSelected)
                        }
                    }
                    .toggleStyle(.button)
                    .buttonStyle(.bordered)
                }
                
                Section {
                    Button("Save") {
                        viewModel.saveExercise()
                    }
                    .foregroundColor(.blue)
                }
            }
            .interactiveDismissDisabled()
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
