//
//  WeightUnit.swift
//  RepBuddy
//
//  Created by Julian Worden on 11/26/22.
//

import Foundation

enum WeightUnit: String, CaseIterable, Identifiable {
    case pounds = "pounds"
    case kilograms = "kilograms"
    
    var id: Self { self }
}
