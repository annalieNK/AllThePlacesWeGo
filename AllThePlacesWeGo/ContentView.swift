//
//  ContentView.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/17/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var places = Places()
    @State private var isButtonDisabled = false
    
    var body: some View {
        TabView {
            MapLayout(searchModel: SearchViewModel())
                .tabItem {
                    Label("Map", systemImage: "map")
                }
        }
        // Add the places object to all views inside TabView
        .environmentObject(places)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
