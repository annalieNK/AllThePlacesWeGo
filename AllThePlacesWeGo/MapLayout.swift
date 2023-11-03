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
    
    @EnvironmentObject var places: Places
    @StateObject var favorites = Favorites()
    
    @StateObject var searchModel: SearchViewModel
    @StateObject private var mapModel = MapViewModel()
    
    @State private var isAddingItem = false
    @State private var showingFilterOptions = false
    @State private var filterTag = FilterTag.default
    //@State private var filterCategory: String = "" //nil
    
    @State private var showTitle = true
    
    enum FilterTag {
        case `default`, beach, hiking, familyActivity, picnic, winery, restaurant, snowActivity, culturalActivity, campground, hotel, other
    }
        
    //    var filteredItems: [Prospect] {
    //        if filterCategory == "personal" {
    //            return prospects.people.filter { $0.tag == "personal"}
    //        } else if filterCategory == "business" {
    //            return prospects.people.filter { $0.tag == "business"}
    //        } else {
    //            return prospects.people
    //        }
    //    }
    
    //    private let address: AddressResult
    //
    //    init(address: AddressResult) {
    //        self.address = address
    //    }
    
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
                                    Image(systemName: "heart.fill")
                                        .font(.title)
                                        .style(for: place)
                                } else {
                                    VStack {
                                        ZStack {
                                            Image(systemName: "circle.fill")
                                                .font(.title) //title
                                                .style(for: place)
                                            
                                            Image(systemName: place.symbol)
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        }
                                        Image(systemName: "arrowtriangle.down.fill")
                                            .font(.caption2)
                                            .style(for: place)
                                            .offset(x: 0, y: -5)
                                    }
                                }
                            }
                            // Rewrite to show only per tapped location
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    showTitle.toggle()
                                }
                            }
                        }
                    }
                }
            }
            // change background color here
            .background(Color.yellow)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isAddingItem = true
                    } label: {
                        Label("Add item", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Button {
                        showingFilterOptions = true
                    } label: {
                        Label("Filter", systemImage: "slider.horizontal.3")
                    }
                }
            }
            .confirmationDialog("Filter items", isPresented: $showingFilterOptions) {
                Button("all") {
                    filterTag = .default //filterCategory = "default"
                    //showingFilterOptions = false
                }
                Button("beach") {
                    filterTag = .beach
                    //showingFilterOptions = false
                }
                Button("hiking") {
                    filterTag = .hiking
                    //showingFilterOptions = false
                }
                Button("family activity") {
                    filterTag = .familyActivity
                    //showingFilterOptions = false
                }
                Button("picnic") {
                    filterTag = .picnic
                    //showingFilterOptions = false
                }
//                Button("winery") {
//                    filterTag = .winery
//                    //showingFilterOptions = false
//                }
                Button("restaurant") {
                    filterTag = .restaurant
                    //showingFilterOptions = false
                }
//                Button("snow activity") {
//                    filterTag = .snowActivity
//                    //showingFilterOptions = false
//                }
                Button("cultural activity") {
                    filterTag = .culturalActivity
                    //showingFilterOptions = false
                }
                Button("campground") {
                    filterTag = .campground
                    //showingFilterOptions = false
                }
                Button("hotel") {
                    filterTag = .hotel
                    //showingFilterOptions = false
                }
                Button("other") {
                    filterTag = .other
                    //showingFilterOptions = false
                }
            } message: {
                Text("Select tag to filter photos")
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
            return places.people
        case .beach:
            return places.people.filter { $0.tag == "beach"}
        case .hiking:
            return places.people.filter { $0.tag == "hiking"}
        case .familyActivity:
            return places.people.filter { $0.tag == "family activity"}
        case .picnic:
            return places.people.filter { $0.tag == "picnic"}
        case .winery:
            return places.people.filter { $0.tag == "winery"}
        case .restaurant:
            return places.people.filter { $0.tag == "restaurant"}
        case .snowActivity:
            return places.people.filter { $0.tag == "snow activity"}
        case .culturalActivity:
            return places.people.filter { $0.tag == "cultural activity"}
        case .campground:
            return places.people.filter { $0.tag == "campground"}
        case .hotel:
            return places.people.filter { $0.tag == "hotel"}
        case .other:
            return places.people.filter { $0.tag == "other"}
        }
    }
}

struct MapLayout_Previews: PreviewProvider {
    static var previews: some View {
        MapLayout(searchModel: SearchViewModel())
    }
}
