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
            switch viewModel.viewState {
            case .dataLoaded:
                List(viewModel.allUserExercises) { exercise in
                    Button {
                        viewModel.exerciseSelected(exercise)
                        dismiss()
                    } label: {
                        Text(exercise.unwrappedName)
                    }
                    .tint(.primary)
                }

            case .dataNotFound:
                NoDataFoundView(message: "You have not created any exercises. You can use the Exercises tab to add exercises.")

            default:
                NoDataFoundView(message: "Invalid ViewState")
            }
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
