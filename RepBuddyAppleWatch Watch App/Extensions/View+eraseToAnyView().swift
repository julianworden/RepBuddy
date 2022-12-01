//
//  View+eraseToAnyView().swift
//  RepBuddy
//
//  Created by Julian Worden on 11/29/22.
//

import Foundation
import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
