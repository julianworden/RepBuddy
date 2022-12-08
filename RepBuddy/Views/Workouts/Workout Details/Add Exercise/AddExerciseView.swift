//
//  AddExerciseToWorkoutView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/29/22.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: AddExerciseViewModel

    init(dataController: DataController, workout: Workout) {
        _viewModel = StateObject(wrappedValue: AddExerciseViewModel(dataController: dataController, workout: workout))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.viewState {
                case .dataLoading:
                    ProgressView()

                case .dataLoaded:
                    List(viewModel.allUserExercises) { exercise in
                        Button {
                            viewModel.exerciseSelected(exercise)
                        } label: {
                            Text(exercise.unwrappedName)
                        }
                        .buttonStyle(.plain)
                    }
                    .interactiveDismissDisabled()

                case .dataNotFound:
                    NoDataFoundView(message: NoDataFoundConstants.addExerciseToWorkoutViewEmptyExercisesList)

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

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView(dataController: DataController.preview, workout: Workout.example)
    }
}
