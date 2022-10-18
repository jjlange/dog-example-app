//
//  ContentView.swift
//  DogApp
//
//  Created by Justin Lange on 18/10/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var network: Network
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("All Dogs")
                    .font(.title)
                    .bold()
                
                VStack(alignment: .leading) {
                    ForEach(network.dogs) { dog in
                        DogInfo(dog: dog)
                    }
                }
            }
            .padding(.vertical)
            .onAppear {
                network.getDogs()
            }
        }
    }
}

struct DogInfo: View {
    var dog: Dog
    
    var body: some View {
        HStack(alignment: .top) {
            NavigationLink(destination: DogView(dog: dog)) {
                Text("\(dog.name)").font(.title)
            }
        }
        .frame(width: 300, alignment: .leading)
        .padding()
        .background(Color(#colorLiteral(red: 0.6667672396, green: 0.7527905703, blue: 1, alpha: 0.2662717301)))
            .cornerRadius(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Network())
    }
}
