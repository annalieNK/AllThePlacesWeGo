//
//  MapViewModel.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/17/23.
//

import Foundation
import MapKit

class MapViewModel: ObservableObject {

    @Published var region = MKCoordinateRegion()
    @Published var annotationItems: [AnnotationItem] = []
    
    @Published var searchResults: [MKMapItem] = []
    
    func getPlace(from address: AddressResult) {
        let request = MKLocalSearch.Request()
        let title = address.title
        let subTitle = address.subtitle
        
        request.naturalLanguageQuery = subTitle.contains(title)
        ? subTitle : title + ", " + subTitle
        
//        let response = MKLocalSearch(request: request)
//        response.start { (response, error) in
//            if let error = error {
//                print("Error performing local search: \(error.localizedDescription)")
//            } else if let firstMapItem = response?.mapItems.first {
//                let placemark = firstMapItem.placemark
//            }
//        }
        
        Task {
            let response = try await MKLocalSearch(request: request).start()
            await MainActor.run {
                self.annotationItems = response.mapItems.map {
                    AnnotationItem(
                        latitude: $0.placemark.coordinate.latitude,
                        longitude: $0.placemark.coordinate.longitude,
                        title: title
                    )
                }
                
                self.region = response.boundingRegion
            }
        }
    }
}
