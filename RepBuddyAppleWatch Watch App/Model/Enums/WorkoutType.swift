//
//  WorkoutType.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

enum WorkoutType: String, CaseIterable, Identifiable {
    case arms = "Arms"
    case legs = "Legs"
    case upperBody = "Upper Body"
    case core = "Core"
    case fullBody = "Full Body"
    
    var id: Self { self }
}
