//
//  AddExerciseToWorkoutView.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/2/22.
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
                case .dataLoaded:
                    List(viewModel.allUserExercises) { exercise in
                        Button {
                            viewModel.exerciseSelected(exercise)
                            dismiss()
                        } label: {
                            Text(exercise.unwrappedName)
                        }
                        .buttonStyle(.plain)
                    }

                case .dataNotFound:
                    NoDataFoundView(message: NoDataFoundConstants.addExerciseToWorkoutViewEmptyExercisesList)

                case .error:
                    EmptyView()

                default:
                    NoDataFoundView(message: "Invalid ViewState")
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
        }
        .onAppear {
            viewModel.fetchAllUserExercises()
        }
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseToWorkoutView(dataController: DataController.preview, workout: Workout.example)
    }
}
