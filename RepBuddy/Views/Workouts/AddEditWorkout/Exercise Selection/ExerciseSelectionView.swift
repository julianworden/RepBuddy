//
//  ExerciseSelectionView.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import SwiftUI

struct ExerciseSelectionView: View {
    @StateObject private var viewModel: ExerciseSelectionViewModel
    
    
    
    @State private var editMode: EditMode = .active
    
    init(dataController: DataController, selectedExercises: [Exercise]) {
        _viewModel = StateObject(wrappedValue: ExerciseSelectionViewModel(dataController: dataController, selectedExercises: selectedExercises))
    }
    
    var body: some View {
        List(selection: $viewModel.selectedExercises) {
            ForEach(viewModel.allUserExercises, id: \.self) { exercise in
                Text(exercise.unwrappedName)
            }
        }
        .navigationTitle("Exercise Selection")
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.editMode, $editMode)
    }
}

struct ExerciseSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseSelectionView(dataController: DataController.preview, selectedExercises: [])
    }
}
