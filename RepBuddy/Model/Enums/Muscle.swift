//
//  Muscle.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

enum Muscle: String, CaseIterable, Identifiable {
    case calves = "Calves"
    
    case biceps = "Biceps"
    case triceps = "Triceps"
    
    case shoulders = "Shoulders"
    case deltoid = "Deltoid"
    case trapezius = "Trapezius"
    case abdomen = "Abdomen"
    
    case pectoralis = "Pectoralis"
    
    var id: Self { self }
}
