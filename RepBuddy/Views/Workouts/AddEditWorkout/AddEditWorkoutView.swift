//
//  AddEditWorkoutView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import SwiftUI

struct AddEditWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: AddEditWorkoutViewModel
    
    init(dataController: DataController, workoutToEdit: Workout? = nil) {
        _viewModel = StateObject(wrappedValue: AddEditWorkoutViewModel(dataController: dataController, workoutToEdit: workoutToEdit))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Type", selection: $viewModel.workoutType) {
                        ForEach(WorkoutType.allCases) {
                            Text($0.rawValue)
                        }
                    }

                    DatePicker("Date", selection: $viewModel.workoutDate, displayedComponents: .date)
                }
                
                Section {
                    Button(viewModel.saveButtonText) {
                        viewModel.saveButtonTapped()
                    }
                }
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        viewModel.dismissView.toggle()
                    }
                }
            }
            .onChange(of: viewModel.dismissView) { _ in
                dismiss()
            }
        }
    }
}

struct AddEditWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditWorkoutView(dataController: DataController.preview)
    }
}
