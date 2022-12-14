//
//  AddExerciseToWorkoutView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/29/22.
//

import SwiftUI

struct AddExerciseToWorkoutView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: AddExerciseToWorkoutViewModel

    init(dataController: DataController, workout: Workout) {
        _viewModel = StateObject(wrappedValue: AddExerciseToWorkoutViewModel(dataController: dataController, workout: workout))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.viewState {
                case .dataLoading:
                    ProgressView()

                case .dataLoaded:
                    List(viewModel.allUserExercises) { exercise in
                        let exerciseIsNotSelectable = viewModel.exerciseIsNotSelectable(exercise)

                        Button {
                            viewModel.exerciseSelected(exercise)
                        } label: {
                            HStack {
                                exerciseIsNotSelectable ? Image(systemName: "checkmark.circle") : nil
                                Text(exercise.unwrappedName)
                            }
                        }
                        .tint(.primary)
                        .disabled(exerciseIsNotSelectable)
                    }
                    .interactiveDismissDisabled()

                case .dataNotFound:
                    NoDataFoundView(message: NoDataFoundConstants.addExerciseToWorkoutViewEmptyExercisesList)
                        .padding(.horizontal)

                case .error:
                    EmptyView()

                default:
                    NoDataFoundView(message: "Invalid ViewState")
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        viewModel.dismissView.toggle()
                    }
                }
            }
            .onAppear {
                viewModel.fetchAllUserExercises()
            }
            .onChange(of: viewModel.dismissView) { _ in
                dismiss()
            }
        }
    }
}

struct AddExerciseToWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseToWorkoutView(dataController: DataController.preview, workout: Workout.example)
    }
}
