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

    let urlString = "https://www.hackingwithswift.com"
    @State private var text = "https://www.hackingwithswift.com"
    
    var body: some View {
        NavigationView {
            VStack {
                if let imageURL = place.imageURL {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 200)
                } else {
                    Text("Image not available")
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
                            
                            Image(systemName: "arrowtriangle.down.fill")
                                .font(.caption)
                                .style(for: place)
                                .offset(x: 0, y: -5)
                        }
                    }
                }
                                
                // create a button to add to or remove from Favorites
                //                Button(favorites.contains(prospect) ? "Remove from Favorites" : "Add to Favorites") {
                //                    if favorites.contains(prospect) {
                //                        favorites.remove(prospect)
                //                    } else {
                //                        favorites.add(prospect)
                //                    }
                //                }
                //                .buttonStyle(.borderedProminent)
                //                .padding()
                //                .disabled(prospect.isContacted == false)
                //                MapAnnotation(coordinate: prospect.coordinate){
                //                    ZStack {
                //                        Image(systemName: "star.circle") //"pin.fill"
                //                            .resizable()
                //                            .style(for: prospect) //.foregroundColor(.red)
                //                            .frame(width: 44, height: 44)
                //                            .background(.white)
                //                            .clipShape(Circle())
                //                    }
                //                }
                //            }
            }
            .navigationBarTitle(place.locationName, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    VStack {
                        Menu {
                            Button(action: {
                                isURLImagePickerPresented = true
                            }) {
                                Text("Add image")
                            }
//                            Button(action: {
//                                
//                            }) {
//                                Text("Add link")
//                            }
                        } label: {
                            Text("Edit")
                        }
                    }
                }
            }
            .sheet(isPresented: $isURLImagePickerPresented) {
                URLImagePicker(place: place)
            }
            //.onAppear(perform: loadLocation)
            //            .onChange(of: prospects.people) {newCoordinate in
            //               if let result = newCoordinate.first {
            //                  region.center = result.coordinate
            //               }
            //            }
            .environmentObject(Favorites()) //favorites
        }
    }
    
    //    func loadLocation() {
    //        prospects.region.center = prospect.coordinate
    //        prospects.region.span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    //    }
    
    
}

struct DetailViewNV_Previews: PreviewProvider {
    static var previews: some View {
        DetailViewNV(place: Place.example)
            .environmentObject(Favorites())
    }
}
