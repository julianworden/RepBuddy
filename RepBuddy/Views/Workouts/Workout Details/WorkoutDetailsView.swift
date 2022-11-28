//
//  WorkoutDetailsView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/27/22.
//

import SwiftUI

struct WorkoutDetailsView: View {
    @StateObject private var viewModel: WorkoutDetailsViewModel
    
    init(workout: Workout) {
        _viewModel = StateObject(wrappedValue: WorkoutDetailsViewModel(workout: workout))
    }
    
    var body: some View {
        List(viewModel.workout.exercisesArray) { exercise in
            Text(exercise.unwrappedName)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.workout.formattedNumericDateTimeOmitted)
    }
}

struct WorkoutDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailsView(workout: Workout.example)
    }
}
