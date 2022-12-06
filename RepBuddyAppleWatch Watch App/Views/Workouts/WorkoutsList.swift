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
                    Text("\(workout.unwrappedType) workout on \(workout.formattedNumericDateTimeOmitted)")
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
