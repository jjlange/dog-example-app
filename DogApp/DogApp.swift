//
//  DogApp.swift
//  DogApp
//
//  Created by Justin Lange on 18/10/2022.
//

import SwiftUI

@main
struct DogApp: App {
    var network = Network()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(network)
        }
    }
}
