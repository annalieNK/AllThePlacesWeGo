//
//  AddressRow.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/17/23.
//

import SwiftUI

struct AddressRow: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var mapModel = MapViewModel()
    
    @ObservedObject var places: Places
    
    let address: AddressResult
    
    
    var body: some View {
        Form {
            Section {
                NavigationLink {
                    SearchView(places: places, address: address)
                } label: {
                    VStack(alignment: .leading) {
                        Text(address.title)
                        Text(address.subtitle)
                            .font(.caption)
                    }
                }
                //.padding(.bottom, 2)
            }
        }
    }
}
