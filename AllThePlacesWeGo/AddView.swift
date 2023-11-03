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
        
    var body: some View {
        NavigationView {
            VStack {
                // Add the type here with a scroll view downwards 
                Text("sdfsdf")
                
                TextField("Search for a location", text: $searchModel.searchText)//, onCommit: performSearch)
                    .padding()
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
                .listStyle(.plain)
                
//                Map(coordinateRegion: $region, annotationItems: searchResults) { mapItem in
//                    MapAnnotation(coordinate: mapItem.placemark.coordinate) {
//                        ZStack {
//                            Image(systemName: "star.circle")
//                                .resizable()
//                                .foregroundColor(.red)
//                                .frame(width: 44, height: 44)
//                                .background(.white)
//                                .clipShape(Circle())
//                        }
//                        .onTapGesture {
//                            selectedCoordinate = mapItem.placemark.coordinate //?? CLLocationCoordinate2D(latitude: -38, longitude: -123)
//                            showingSaveConfirmation = true
//                        }
//                    }
//                }
                //Map(coordinateRegion: $map)
            }
            //.edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("Add to collection")
//            .confirmationDialog("Add this location to your collection", isPresented: $showingSaveConfirmation) {
//                Button("Add location") {
//                    guard let selectedCoordinate = selectedCoordinate else { return }
//                    prospects.add(latitude: selectedCoordinate.latitude, longitude: selectedCoordinate.longitude, locationName: searchModel.searchText)
//                    dismiss()
//                }
//                Button("Cancel", role: .cancel) { }
//            } message: {
//                Text("Add this location to your collection")
//            }
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
    
//    private var saveButtonToolbar: some View {
//        Button("Save") {
//            guard let selectedCoordinate = selectedCoordinate else { return }
//            //print(searchText)
//            prospects.add(latitude: selectedCoordinate.latitude, longitude: selectedCoordinate.longitude, locationName: prospects.searchText)
//            dismiss()
//        }
//    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(places: Places(), searchModel: SearchViewModel())
    }
}
