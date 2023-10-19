//
//  ContentView.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/17/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    // Create and store a single instance of the Prospect class
    @StateObject var places = Places()
    //@StateObject var favorites = Favorites()
    @State private var isButtonDisabled = false
    
    var body: some View {
        TabView {
            MapLayout(searchModel: SearchViewModel())
                .tabItem {
                    Label("Map", systemImage: "map")
                }
        }
        // Add the prospects object to all views inside TabView
        .environmentObject(places)
        //.environmentObject(favorites)
        //.environmentObject(Favorites())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
