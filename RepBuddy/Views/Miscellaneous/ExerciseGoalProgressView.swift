//
//  ExerciseGoalProgressView.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/12/22.
//

import SwiftUI

struct ExerciseGoalProgressView: View {
    let exercise: Exercise

    var body: some View {
        if let highestRepSetWeight = exercise.highestRepSetWeight {
            if highestRepSetWeight > exercise.goalWeight {
                ProgressView(
                    // Prevents runtime error for providing value higher than total value
                    value: Double(exercise.goalWeight),
                    total: Double(exercise.goalWeight)
                )
                .tint(highestRepSetWeight >= exercise.goalWeight ? .green : .blue)
            } else {
                ProgressView(
                    value: Double(highestRepSetWeight),
                    total: Double(exercise.goalWeight)
                )
                .tint(highestRepSetWeight >= exercise.goalWeight ? .green : .blue)
            }
        }
    }
}

struct ExerciseGoalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseGoalProgressView(exercise: Exercise.example)
    }
}
