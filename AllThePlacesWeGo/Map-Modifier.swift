//
//  Map-Modifier.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/17/23.
//

import MapKit

extension MKMapItem: Identifiable {
    public var id: String {
        return self.name ?? UUID().uuidString
    }
}
