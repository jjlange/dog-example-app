//
//  TabBarView.swift
//  DogApp
//
//  Created by Justin Lange on 19/10/2022.
//

import SwiftUI

struct TabBarView: View {
    @StateObject var network = Network()
    var body: some View {
        TabView {
            NavigationStack {
                ContentView().environmentObject(network)
            }.tabItem {
                Label("List", systemImage: "list.dash")
            }
            
            NavigationStack {
                FavouriteView().environmentObject(network)
            }.tabItem {
                Label("Favourite", systemImage: "heart")
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
