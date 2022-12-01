//
//  ContentView.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/1/22.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel

    init(dataController: DataController) {
        _viewModel = StateObject(wrappedValue: ContentViewModel(dataController: dataController))
    }

    var body: some View {
        List(viewModel.exercises) { exercise in
            Text(exercise.unwrappedName)
        }
        .onAppear(perform: viewModel.setupExercisesController)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dataController: DataController.preview)
    }
}
