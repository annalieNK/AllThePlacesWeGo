//
//  SplashView.swift
//  AllThePlacesWeGo
//
//  Created by Annalie Kruseman on 10/19/23.
//

import SwiftUI

struct SplashView: View {
    
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if self.isActive {
                ContentView() //EnterView()
            } else {
                ZStack {
                    GeometryReader { geo in
                        Image("background")
                            .resizable()
                            //.scaledToFit()
                            //.frame(width: geo.size.width, height: geo.size.height)
                            .aspectRatio(contentMode: .fill)
                    }
                    VStack {
                        Text("All Those Places")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                            .padding()
                        Text("We Visit")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                            .padding()
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
    
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
