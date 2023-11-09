//
//  AddView.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/17/23.
//

import SwiftUI
import CoreLocation
import MapKit

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var places: Places //@EnvironmentObject
    @StateObject var searchModel: SearchViewModel
    
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    //@State var searchResults: [AnnotationItem]
    //@State private var selectedResult: MKMapItem?
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @State private var showingSaveConfirmation = false
    
    @State private var tag = ""
    @State private var icon = ""
    
    let tags = ["beach", "hiking", "family activity", "picnic", "winery", "restaurant", "snow activity", "cultural activity", "campground", "hotel", "other"]
    let icons = ["beach.umbrella.fill", "figure.hiking", "figure.and.child.holdinghands", "basket.fill", "wineglass.fill", "fork.knife", "snowflake", "theatermask.and.paintbrush.fill", "tent.fill", "house.lodge.fill", "star.fill"]
    
    @State private var selectedOption = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Search for a location", text: $searchModel.searchText)//, onCommit: performSearch)
                    //.padding()
                        .autocorrectionDisabled()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    //.background(Color.init(uiColor: .systemBackground))
                        .onReceive(
                            searchModel.$searchText.debounce(
                                for: .seconds(0.5), //1
                                scheduler: DispatchQueue.main)
                        ) {
                            searchModel.searchAddress($0)
                        }
                        .overlay {
                            ClearButton(text: $searchModel.searchText)
                                .padding(.trailing)
                                .padding(.top, 8)
                        }
                    List(self.searchModel.results) { address in
                        AddressRow(places: places, address: address)
                        //.listRowBackground(backgroundColor)
                    }
                }
                //.listStyle(.plain)
            }
            //.edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("Discover", displayMode: .inline)
        }
    }
    
    func performSearch() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        searchRequest.region = region
        
        let localSearch = MKLocalSearch(request: searchRequest)
        localSearch.start { response, error in
            if let response = response {
                searchResults = response.mapItems
                
                // return only the first result
                if let firstResult = response.mapItems.first {
                    region.center = firstResult.placemark.coordinate
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(places: Places(), searchModel: SearchViewModel())
    }
}
