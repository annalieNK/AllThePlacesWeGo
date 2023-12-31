//
//  MapLayout.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/17/23.
//

import SwiftUI
import MapKit

struct MapLayout: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @EnvironmentObject var places: Places
    @StateObject var favorites = Favorites()
    
    @State private var selectedPlace: Place?
    
    @StateObject var searchModel: SearchViewModel
    @StateObject private var mapModel = MapViewModel()
    
    @State private var isAddingItem = false
    @State private var showingFilterOptions = false
    @State private var filterTag = FilterTag.default
        
    @State private var showTitle = true
        
    enum FilterTag {
        case `default`, beach, hiking, familyActivity, picnic, winery, restaurant, snowActivity, culturalActivity, campground, hotel, other
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $places.region, annotationItems: filteredItems) { place in  //prospects.people
                    MapAnnotation(coordinate: place.coordinate) {
                        NavigationLink {
                            // Add either DetailView Not Visited or Visited
                            if place.isVisited {
                                DetailViewV(place: place)
                            } else {
                                DetailViewNV(place: place)
                            }
                        } label: {
                            //PlaceAnnotationView(title: place.locationName, symbol: place.symbol)
                            VStack(spacing: 0) {
                                Text(place.locationName)
                                    .font(.callout)
                                    .padding(5)
                                    .background(Color(.white))
                                    .cornerRadius(10)
                                    .opacity(showTitle ? 0 : 1)
                                
                                if favorites.contains(place) {
                                    VStack {
                                        ZStack {
                                            Image(systemName: "heart.fill")
                                                .font(.title)
                                                .style(for: place)
                                            
                                            Image(systemName: place.symbol)
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        }
                                    }
                                } else {
                                    VStack {
                                        ZStack {
                                            Image(systemName: "circle.fill")
                                                .font(selectedPlace == place ? .largeTitle : .title)
                                                .opacity(selectedPlace == place ? 1 : 0.5)
                                                .style(for: place)
                                            
                                            Image(systemName: place.symbol)
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    showTitle.toggle()
                                    selectedPlace = place
                                }
                            }
                        }
                    }
                }
                .gesture(
                    TapGesture()
                        .onEnded { value in
                            selectedPlace = nil
                            showTitle = true
                        }
                )
            }
            .background(.backgroundGradient, ignoresSafeAreaEdges: horizontalSizeClass == .compact ? [.all] : [.all])
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isAddingItem = true
                    } label: {
                        Label("Add item", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .automatic) {
                    VStack {
                        Menu {
                            Button(action: {
                                filterTag = .default
                            }) {
                                Text("all")
                            }
                            Button(action: {
                                filterTag = .beach
                            }) {
                                Text("beach")
                            }
                            Button(action: {
                                filterTag = .hiking
                            }) {
                                Text("hiking")
                            }
                            Button(action: {
                                filterTag = .familyActivity
                            }) {
                                Text("family activity")
                            }
                            Button(action: {
                                filterTag = .picnic
                            }) {
                                Text("picnic")
                            }
                            Button(action: {
                                filterTag = .restaurant
                            }) {
                                Text("restaurant")
                            }
                            Button(action: {
                                filterTag = .culturalActivity
                            }) {
                                Text("cultural activity")
                            }
                            Button(action: {
                                filterTag = .campground
                            }) {
                                Text("campground")
                            }
                            Button(action: {
                                filterTag = .hotel
                            }) {
                                Text("hotel")
                            }
                            Button(action: {
                                filterTag = .other
                            }) {
                                Text("other")
                            }
                        } label: {
                            Label("Filter", systemImage: "slider.horizontal.3")
                        }
                    }
                }
            }
            .sheet(isPresented: $isAddingItem) {
                AddView(places: places, searchModel: SearchViewModel())
                //.interactiveDismissDisabled()
                    .presentationDetents([.fraction(0.9)]) //, .medium //[.height(400), .fraction(0.8)]
                    .presentationBackground(.regularMaterial)
                    .presentationBackgroundInteraction(.enabled(upThrough: .large))
            }
        }
        .environmentObject(favorites)
    }
    
    var filteredItems: [Place] {
        switch filterTag {
        case .default:
            return places.items
        case .beach:
            return places.items.filter { $0.tag == "beach"}
        case .hiking:
            return places.items.filter { $0.tag == "hiking"}
        case .familyActivity:
            return places.items.filter { $0.tag == "family activity"}
        case .picnic:
            return places.items.filter { $0.tag == "picnic"}
        case .winery:
            return places.items.filter { $0.tag == "winery"}
        case .restaurant:
            return places.items.filter { $0.tag == "restaurant"}
        case .snowActivity:
            return places.items.filter { $0.tag == "snow activity"}
        case .culturalActivity:
            return places.items.filter { $0.tag == "cultural activity"}
        case .campground:
            return places.items.filter { $0.tag == "campground"}
        case .hotel:
            return places.items.filter { $0.tag == "hotel"}
        case .other:
            return places.items.filter { $0.tag == "other"}
        }
    }
}

struct MapLayout_Previews: PreviewProvider {
    static var previews: some View {
        MapLayout(searchModel: SearchViewModel())
    }
}
