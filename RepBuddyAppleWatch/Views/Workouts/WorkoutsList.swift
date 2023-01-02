//
//  WorkoutsList.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/6/22.
//

import SwiftUI

struct WorkoutsList: View {
    @ObservedObject var viewModel: WorkoutsViewModel

    var body: some View {
        List {
            ForEach(viewModel.workouts) { workout in
                NavigationLink {
                    WorkoutDetailsView(dataController: viewModel.dataController, workout: workout)
                } label: {
                    VStack(alignment: .leading) {
                        Text(workout.unwrappedDate.numericDateNoTime)
                        Text("\(workout.unwrappedType) Workout")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct WorkoutsList_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsList(viewModel: WorkoutsViewModel(dataController: DataController.preview))
    }
}
