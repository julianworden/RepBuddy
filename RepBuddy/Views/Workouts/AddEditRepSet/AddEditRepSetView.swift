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
        Form {
            Section("How many reps?") {
                TextField("Rep count", value: $viewModel.repCount, format: .number)
            }
            
            Section {
                Button("Confirm") {
                    viewModel.confirmButtonTapped()
                }
            }
            
            if viewModel.repSetToEdit != nil {
                Section {
                    Button("Delete Set", role: .destructive) {
                        viewModel.deleteRepSet()
                    }
                }
            }
        }
        .navigationTitle(viewModel.navigationBarTitleText)
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

struct AddEditRepSetView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditRepSetView(dataController: DataController.preview, workout: Workout.example, exercise: Exercise.example)
    }
}
