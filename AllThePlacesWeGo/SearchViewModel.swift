//
//  SearchViewModel.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/17/23.
//

import Foundation
import MapKit

class SearchViewModel: NSObject, ObservableObject {
    
    @Published private(set) var results: Array<AddressResult> = []
    @Published var searchText = ""
    
    private lazy var localSearchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }()
    
    func searchAddress(_ searchText: String) {
        guard searchText.isEmpty == false else { return }
        localSearchCompleter.queryFragment = searchText
    }
    
    
    //
    //    func performSearch() {
    //        let request = MKLocalSearch.Request()
    //        request.naturalLanguageQuery = searchText
    //        request.region = region
    //
    //        let search = MKLocalSearch(request: request)
    //        search.start { response, error in
    //            if let response = response {
    //                searchResults = response.mapItems
    //
    //                if let firstResult = response.mapItems.first {
    //                    region.center = firstResult.placemark.coordinate
    //                }
    //            }
    //        }
    //    }
}

extension SearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task { @MainActor in
            results = completer.results.map {
                AddressResult(title: $0.title, subtitle: $0.subtitle)
            }
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
