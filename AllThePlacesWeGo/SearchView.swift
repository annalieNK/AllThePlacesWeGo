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
    //    @State private var isSaveItem = false
    
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
                }//,
            //                annotationContent: { item in
            //                    MapAnnotation(coordinate: item.coordinate) {
            //                        VStack {
            //                            Menu {
            //                                Button(action: {
            //                                    tag = "beach"
            //                                    //icon = "beach.umbrella.fill"
            //                                    selectedCoordinate = item.coordinate
            //                                }) {
            //                                    Label("beach", systemImage: "beach.umbrella.fill")
            //                                }
            //                                Button(action: {
            //                                    tag = "hiking"
            //                                    //icon = "figure.hiking"
            //                                    selectedCoordinate = item.coordinate
            //                                }) {
            //                                    Label("hiking", systemImage: "figure.hiking")
            //                                }
            //                            } label: {
            //                                VStack(spacing: 0) {
            //                                    Image(systemName: "mappin.circle.fill")
            //                                        .font(.title)
            //                                        .foregroundColor(.red)
            //
            //                                    Image(systemName: "arrowtriangle.down.fill")
            //                                        .font(.caption)
            //                                        .foregroundColor(.red)
            //                                        .offset(x: 0, y: -5)
            //                                }
            //                                //PlaceAnnotationView(title: "", symbol: "mappin")
            ////                                ZStack {
            ////                                    Image(systemName: "star.circle")
            ////                                        .resizable()
            ////                                        .foregroundColor(.red)
            ////                                        .frame(width: 44, height: 44)
            ////                                        .background(.white)
            ////                                        .clipShape(Circle())
            ////                                }
            //
            //                                .onTapGesture {
            //                                    selectedCoordinate = item.coordinate
            //                                    //showingSaveConfirmation = true
            //                                }
            //                            }
            //                        }
            //                    }
            //                }
            //            )
        }
        //}
        .frame(width: 400, height: 650) // Set the desired width and height
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
