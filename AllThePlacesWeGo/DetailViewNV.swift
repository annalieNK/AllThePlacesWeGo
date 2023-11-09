//
//  DetailViewNV.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/17/23.
//

import SwiftUI
import MapKit

struct DetailViewNV: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    @EnvironmentObject var places: Places
    @EnvironmentObject var favorites: Favorites
    
    //let prospect: Prospect
    // Use when editing details as a class object
    @ObservedObject var place: Place
    
    @State private var editedURLString = ""
    @State private var isURLImagePickerPresented = false
    @State private var showingDeleteAlert = false

    let urlString = "https://www.hackingwithswift.com"
    @State private var text = "https://www.hackingwithswift.com"
    
    var body: some View {
        NavigationView {
            VStack { 
                Spacer()
                if let imageURL = place.imageURL {
                    GeometryReader { geo in
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                //.aspectRatio(contentMode: .fit)
                                //.frame(maxWidth: .infinity)
                                .scaledToFit()
                                .frame(width: geo.size.width, height: geo.size.height) //
//                                .containerRelativeFrame(.horizontal) { size, axis in
//                                        size * 0.8
//                                    }
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 200)
                    }
                } else {
                    //Text("Image not available")
                }
                
//                Button("Visit Apple") {
//                    //openURL(URL(string: "https://www.apple.com")!)
//                    UIApplication.shared.open(URL(string: "https://www.apple.com")!)
//                }
                
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: place.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )), annotationItems: [Place(latitude: place.latitude, longitude: place.longitude, locationName: place.locationName, tag: place.tag, urlImageString: place.urlImageString)]) { p in
                    MapAnnotation(coordinate: p.coordinate) {
                        VStack {
                            ZStack {
                                Image(systemName: "circle.fill")
                                    .font(.title)
                                    .style(for: place)
                                
                                Image(systemName: place.symbol)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            //.edgesIgnoringSafeArea(.top)
            .navigationBarTitle(place.locationName, displayMode: .inline)
            .alert("Delete location", isPresented: $showingDeleteAlert) {
                Button(action: {
                    places.deleteItem(item: place)
                }) {
                    Text("Delete")
                }
                Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Are you sure to delete this location from your collection?")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    VStack {
                        Menu {
                            if place.isVisited {
                                Button(action: {
                                    places.toggle(place)
                                }) {
                                    Text("Mark not visited")
                                }
                            } else {
                                Button(action: {
                                    places.toggle(place)
                                }) {
                                    Text("Mark visited")
                                }
                            }
                            
                            Button(action: {
                                isURLImagePickerPresented = true
                            }) {
                                Text("Add image")
                            }
//                            Button(action: {
//                            }) {
//                                Text("Add link")
//                            }
                        } label: {
                            Text("Edit")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete this location", systemImage: "trash")
                    }
                }
            }
            .sheet(isPresented: $isURLImagePickerPresented) {
                URLImagePicker(place: place)
            }
            .environmentObject(Favorites())
        }
    }
}

struct DetailViewNV_Previews: PreviewProvider {
    static var previews: some View {
        DetailViewNV(place: Place.example)
            .environmentObject(Favorites())
    }
}
