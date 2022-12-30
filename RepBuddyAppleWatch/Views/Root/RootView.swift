//
//  RootView.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/2/22.
//

import SwiftUI

struct RootView: View {
    @StateObject private var viewModel: RootViewModel

    init(dataController: DataController) {
        _viewModel = StateObject(wrappedValue: RootViewModel(dataController: dataController))
    }

    var body: some View {
        TabView {
            ExercisesView(dataController: viewModel.dataController)
            WorkoutsView(dataController: viewModel.dataController)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(dataController: DataController.preview)
    }
}
