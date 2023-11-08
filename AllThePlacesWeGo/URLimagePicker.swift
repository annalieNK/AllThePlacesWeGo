//
//  URLimagePicker.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/17/23.
//

import SwiftUI

struct URLImagePicker: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var places: Places
    
    @ObservedObject var place: Place
    
    @State private var editedURLImageString = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Image URL")) {
                    TextEditor(text: self.$editedURLImageString)
                        .autocapitalization(.none)
                }
            }
            .navigationBarItems(trailing: Button("Save") {
                places.update(item: place, withName: editedURLImageString)
                dismiss()
            })
        }
    }
    
    init(place: Place) {
        self.place = place
        
        _editedURLImageString = State(initialValue: place.urlImageString)
    }
}
