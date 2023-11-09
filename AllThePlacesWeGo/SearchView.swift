//
//  SearchView.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/17/23.
//

import SwiftUI
import MapKit

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var places: Places
    @StateObject private var mapModel = MapViewModel()
    
    let address: AddressResult
    
    let tags = ["other", "beach", "hiking", "family activity", "picnic", "winery", "restaurant", "snow activity", "cultural activity", "campground", "hotel"]
    let icons = ["star.fill", "beach.umbrella.fill", "figure.hiking", "figure.and.child.holdinghands", "basket.fill", "wineglass.fill", "fork.knife", "snowflake", "theatermask.and.paintbrush.fill", "tent.fill", "house.lodge.fill"]
    
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var showingSaveConfirmation = false
    
    @State private var tag = ""
    @State private var icon = ""
    @State private var urlImageString = ""
    
    //    init(address: AddressResult) {
    //        self.address = address
    //    }
    
    var body: some View {
        VStack {
            Section {
                Picker("Select type of activity", selection: $tag) {
                    ForEach(tags, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            
            //ZStack {
            Map(
                coordinateRegion: $mapModel.region,
                annotationItems: mapModel.annotationItems) { item in
                    MapMarker(coordinate: item.coordinate)
                }
        }
        .frame(width: 400, height: 650) 
        .cornerRadius(10)
        .onAppear {
            self.mapModel.getPlace(from: address)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    guard let selectedCoordinate = mapModel.annotationItems.first?.coordinate else { return } //selectedCoordinate else { return }
                    places.add(latitude: selectedCoordinate.latitude, longitude: selectedCoordinate.longitude, locationName: address.title, tag: tag, urlImageString: urlImageString)
                    dismiss()
                } label: {
                    Text("Save")
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
