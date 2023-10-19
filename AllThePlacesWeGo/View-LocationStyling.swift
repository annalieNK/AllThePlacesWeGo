//
//  View-LocationStyling.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/17/23.
//

import SwiftUI

extension View {
    func style(for place: Place) -> some View {
        if place.isVisited == true {
            return self.foregroundColor(.green)
        } else {
            return self.foregroundColor(.red)
        }
    }
}

struct PlaceAnnotationView: View {
    @State private var showTitle = true
    
    let title: String
    
    let symbol: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.callout)
                .padding(5)
                .background(Color(.white))
                .cornerRadius(10)
                .opacity(showTitle ? 0 : 1)
                        
            ZStack {
                Image(systemName: "circle.fill") //mappin.circle.fill
                    .font(.title)
                    //.foregroundColor(.red)
                
                Image(systemName: symbol)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            
            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                //.foregroundColor(.red)
                .offset(x: 0, y: -5)
        }
        .onTapGesture {
            withAnimation(.easeInOut) {
                showTitle.toggle()
            }
        }
    }
}
