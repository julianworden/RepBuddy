//
//  AddExerciseView.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/2/22.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: AddExerciseViewModel

    init(dataController: DataController, workout: Workout) {
        _viewModel = StateObject(wrappedValue: AddExerciseViewModel(dataController: dataController, workout: workout))
    }

    var body: some View {
        List(viewModel.allUserExercises) { exercise in
            Button {
                viewModel.exerciseSelected(exercise)
            } label: {
                Text(exercise.unwrappedName)
            }
            .tint(.primary)
        }
        .onAppear {
            viewModel.fetchAllUserExercises()
        }
        .onChange(of: viewModel.dismissView) { _ in
            dismiss()
        }
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView(dataController: DataController.preview, workout: Workout.example)
    }
}
