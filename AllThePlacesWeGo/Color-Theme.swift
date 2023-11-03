//
//  Color-Theme.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/19/23.
//

import Foundation
import SwiftUI

extension ShapeStyle where Self == Color {
    static var pinkColor: Color {
        Color(hue: 0.95, saturation: 1, brightness: 1, opacity: 0.5) //hue: 0.12 (yellowColor)
    }

    static var blueColor: Color {
        Color(hue: 0.65, saturation: 1, brightness: 1, opacity: 0.5) //hue: 0.05 (orangeColor)
    }
    
    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [pinkColor, blueColor],
            startPoint: .top, endPoint: .bottom)
    }
}
