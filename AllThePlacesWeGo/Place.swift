//
//  Place.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/17/23.
//

import Foundation
import SwiftUI
import MapKit

class Place: Identifiable, Codable, Equatable, ObservableObject {
    var id = UUID()
    
    let latitude: Double
    let longitude: Double
    
    var locationName: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var tag: String
    
    var urlImageString: String
    
    //var webLinks: [WebLink]
    
    var symbol: String {
        switch tag {
        case "beach": return "beach.umbrella.fill"
        case "hiking": return "figure.hiking"
        case "family activity": return "figure.and.child.holdinghands"
        case "picnic": return "basket.fill"
        case "winery": return "wineglass.fill"
        case "restaurant": return "fork.knife"
        case "snow activity": return "snowflake"
        case "cultural activity": return "theatermask.and.paintbrush.fill"
        case "campground": return "tent.fill"
        case "hotel": return "house.lodge.fill" //bed.double.fill
        //case "playground": return ""
        case "other": return "star.fill"
        default: return "heart.fill"
        }
    }
    
    var imageURL: URL? {
        URL(string: urlImageString)
    }
        
    // prevent this property to be changed outside this file (through the use of the toggle function)
    fileprivate(set) var isVisited = false
    
    init(latitude: Double, longitude: Double, locationName: String, tag: String, urlImageString: String) { //, webLinks: [WebLink]
        self.id = UUID()
        
        self.latitude = latitude
        self.longitude = longitude
        self.locationName = locationName
        self.tag = tag
        self.urlImageString = urlImageString
        
        //self.webLinks = webLinks
    }
    
    static let example = Place(latitude: 38.0, longitude: -124.0, locationName: "Home", tag: "personal", urlImageString: "https://hws.dev/img/logo.png") 
    
    // write a comparison function to make sure locations are unique (according to the Identifiable and Equatable protocols)
    static func ==(lhs: Place, rhs: Place) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: Place, rhs: Place) -> Bool {
        lhs.locationName < rhs.locationName
    }
}

@MainActor class Places: ObservableObject {
    @Published private(set) var items: [Place]
    @Published var selectedPlace: Place?
    
    //@Published var selectedCoordinate: CLLocationCoordinate2D?
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.773972, longitude: -122.431297),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    
//    @Published private(set) var results: Array<AddressResult> = []
//    @Published var searchText = ""
    
    //@Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: prospect.latitude, longitude: prospect.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    let saveKey = "SavedData"
    let savePath = FileManager.documentsDirectory.appendingPathExtension("SavedData")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            items = try JSONDecoder().decode([Place].self, from: data)
        } catch {
            items = []
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(self.items)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
    
    func add(latitude: Double, longitude: Double, locationName: String, tag: String, urlImageString: String) {
        let newPlace = Place(latitude: latitude, longitude: longitude, locationName: locationName, tag: tag, urlImageString: urlImageString)
        items.append(newPlace)
        save()
    }
    
    func update(item: Place, withName urlImageString: String) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].urlImageString = urlImageString
            save()
        }
    }
    
//    func removeRows(at offsets: IndexSet) {
//        self.people.remove(atOffsets: offsets)
//        save()
//        print("item deleted")
//    }
    
    func removeItems(at offsets: IndexSet, in inputArray: [Place]) {
        var objectsToDelete = IndexSet()

        for offset in offsets {
            let item = inputArray[offset]

            if let index = items.firstIndex(of: item) {
                objectsToDelete.insert(index)
            }
        }

        items.remove(atOffsets: objectsToDelete)
    }
    
    func deleteItem(item: Place) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
        }
    }
    
    func toggle(_ place: Place) {
        objectWillChange.send()
        place.isVisited.toggle()
        save()
    }
}
