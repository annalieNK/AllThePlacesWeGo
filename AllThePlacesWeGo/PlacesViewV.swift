//
//  PlacesViewV.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/17/23.
//

import SwiftUI
import MapKit

struct PlacesViewV: View {
    
    // Find the object, attach it to a property, and keep it up to date over time
    @EnvironmentObject var places: Places
    @StateObject var favorites = Favorites()
    
    //@AppStorage("showingMap") private var showingMap = true
    
    //@State private var isAddingItem = false
    @State private var showingFilterOptions = false
    @State private var filterTag = FilterTag.default
    
    enum FilterType {
        case none, visited, notvisited
    }
    
    enum FilterTag {
        case `default`, beach, hiking, familyActivity, picnic, winery, restaurant, snowActivity, culturalActivity, campground, hotel, other
    }
    
    let filter: FilterType
    
    var body: some View {
        NavigationView {
            List {
                ForEach(visitedPlaces) { place in
                    //ItemsSection(filter: .beach, title: "Beach")
                    
                    // check if struct contains property
                    // if so: return headline with property name
                    // and list of values
                    
                    
                    VStack(alignment: .leading) {
                        NavigationLink {
                            DetailViewNV(place: place)
                        } label: {
                            HStack {
                                Text(place.locationName)
                                    .font(.headline)
                                
                                // add a heart to show favorite
                                if favorites.contains(place) {
                                    Spacer()
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        if place.isVisited {
                            Button {
                                places.toggle(place)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                places.toggle(place)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                        }
                    }
                }
                .onDelete { index in
                    places.removeItems(at: index, in: visitedPlaces) //prospects.removeRows(at: index)
                }
            }
            .navigationTitle(title)
            .toolbar {
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
                //                Button("picnic") {
                //                    filterTag = .picnic
                //                    //showingFilterOptions = false
                //                }
                //                Button("winery") {
                //                    filterTag = .winery
                //                    //showingFilterOptions = false
                //                }
                Button("restaurant") {
                    filterTag = .restaurant
                    //showingFilterOptions = false
                }
                Button("snow activity") {
                    filterTag = .snowActivity
                    //showingFilterOptions = false
                }
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
            //            .sheet(isPresented: $isAddingItem) {
            //                AddView(prospects: prospects, searchModel: SearchViewModel())
            //                    //.disabled(filter == .contacted)
            //            }
        }
        .environmentObject(favorites)
    }
    
    var title: String {
        switch filter {
        case .none:
            return "All places"
        case .visited:
            return "Visited Places"
        case .notvisited:
            return "Not Visited Places"
        }
    }
    
    var visitedPlaces: [Place] {
        switch filter {
        case .none:
            return places.people
        case .visited:
            return places.people.filter { $0.isVisited }
        case .notvisited:
            return places.people.filter { !$0.isVisited }
        }
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

struct PlacesViewV_Previews: PreviewProvider {
    static var previews: some View {
        PlacesViewV(filter: .none)
            .environmentObject(Places())
    }
}
