//
//  ExercisesViewGoalProgressView.swift
//  RepBuddy
//
//  Created by Julian Worden on 12/13/22.
//

import SwiftUI

// TODO: ADD A VIEWMODEL FOR THIS SO THAT THE PROGRESSVIEW WILL UPDATE IN REALTIME
struct ExercisesViewGoalProgressView: View {
    let exercise: Exercise

    var body: some View {
        if let highestRepSetWeight = exercise.highestRepSetWeight {

            // Goal achieved
            if highestRepSetWeight >= exercise.goalWeight {
                ProgressView(
                    // Prevents runtime error for providing value higher than total value
                    value: Double(exercise.goalWeight),
                    total: Double(exercise.goalWeight)
                )
                .tint(.green)

            // Goal not achieved
            } else {
                ProgressView(
                    value: Double(highestRepSetWeight),
                    total: Double(exercise.goalWeight)
                )
            }
        }
    }
}

struct ExercisesViewGoalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesViewGoalProgressView(exercise: Exercise.example)
    }
}
