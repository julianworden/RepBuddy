//
//  NoDataFoundView.swift
//  RepBuddyAppleWatch Watch App
//
//  Created by Julian Worden on 12/6/22.
//

import SwiftUI

struct NoDataFoundView: View {
    let message: String

    var body: some View {
        Text(message)
            .italic()
            .multilineTextAlignment(.center)
    }
}

struct NoDataFoundView_Previews: PreviewProvider {
    static var previews: some View {
        NoDataFoundView(message: "No Data Found")
    }
}
