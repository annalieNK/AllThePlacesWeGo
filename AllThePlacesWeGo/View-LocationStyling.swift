//
//  View-LocationStyling.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/17/23.
//

import SwiftUI

extension View {
    func style(for place: Place) -> some View {
        if place.isContacted == true {
            return self.foregroundColor(.green)
        } else {
            return self.foregroundColor(.red)
        }
    }
}
