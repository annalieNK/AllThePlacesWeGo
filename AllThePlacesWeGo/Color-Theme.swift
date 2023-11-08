//
//  Color-Theme.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/19/23.
//

import Foundation
import SwiftUI

extension ShapeStyle where Self == Color {
    static var yellowColor: Color {
        Color(hue: 0.12, saturation: 1, brightness: 1, opacity: 0.5) //hue: 0.12 (yellowColor) //0.95: pink
    }

    static var orangeColor: Color {
        Color(hue: 0.05, saturation: 1, brightness: 1, opacity: 0.5) //hue: 0.05 (orangeColor) //0.65: blue
    }
    
    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [orangeColor, yellowColor],
            startPoint: .top, endPoint: .bottom)
    }
}
