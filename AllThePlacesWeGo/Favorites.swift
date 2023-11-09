//
//  Favorites.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/17/23.
//

import Foundation

// build a class that can be changed
class Favorites: ObservableObject {
    // the actual resorts the user has favorited
    private var favoriteItems: Set<String>
    //private var people: Set<String>
    
    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favorites"
    
    init() {
        // load our saved data
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
                favoriteItems = decoded
                return
            }
        }
        favoriteItems = []
    }
    
    // returns true if our set contains this item
    func contains(_ place: Place) -> Bool {
        favoriteItems.contains(place.id.uuidString)
    }
    
    // adds the resort to our set, updates all views, and saves the change
    func add(_ place: Place) {
        objectWillChange.send()
        favoriteItems.insert(place.id.uuidString)
        save()
    }
    
    // removes the resort from our set, updates all views, and saves the change
    func remove(_ place: Place) {
        objectWillChange.send()
        favoriteItems.remove(place.id.uuidString)
        save()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(favoriteItems) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
