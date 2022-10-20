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
    
    @State var likes = [Like]()
    @State var dogs = [Dog]()
    
    @State var loading: Bool = true
    
    var body: some View {
        ScrollView {
            if(loading) {
                ProgressView()
            } else {
                VStack(alignment: .leading) {
                    ForEach(dogs) { dog in
                        DogInfo(dog: dog, liked: likes.contains(where: {$0.image_id == dog.image.id}), likes: $likes)
                    }
                }
            }
        }
        .environmentObject(network)
        .onAppear() {
            network.getDogs() { error, success, result in
                if let error = error {
                    print(error)
                    return
                }
                
                if(success) {
                    if let result = result {
                        dogs = result
                    }
                }
            }
            
            network.getLikes(sub_id: "user") { error, success, result in
                if let error = error {
                    print(error)
                    return
                }
                
                if(success) {
                    if let result = result {
                        likes = result
                        loading = false
                    }
                }
            }
        }.navigationTitle("List")
    }
}

struct DogInfo: View {
    @State var dog: Dog
    @State var liked: Bool
    @Binding var likes: [Like]
    
    @EnvironmentObject var network: Network
    
    var body: some View {
        HStack(alignment: .center) {
            NavigationLink(destination: DogView(dog: dog)) {
                Text("\(dog.name))")
            }
            .padding(5).padding(.horizontal, 10)
            .background(Color(#colorLiteral(red: 0.6667672396, green: 0.7527905703, blue: 1, alpha: 0.2662717301)))
                .cornerRadius(20)
            
            Spacer()
            
            Button(action: {
                Task {
                    // Check if image is already in our favourites
                    
                    if(liked == true) {
                        for like in likes {
                            if(dog.image.id == like.image_id) {
                                // Remove the like from the list
                                network.removeFavourite(id: like.id) { error, success in
                                    if let error = error {
                                        print("An error occured. \(error)")
                                        return
                                    }
                                    
                                    if(success) {
                                        network.getLikes(sub_id: "user") { error, success, result in
                                            if let error = error {
                                                print(error)
                                                return
                                            }
                                            
                                            if(success) {
                                                if let result = result {
                                                    likes = result
                                                    liked = false
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        network.addFavourite(image_id: dog.image.id, sub_id: "user") { error, success in
                            if let error = error {
                                print(error)
                                return
                            }
                            
                            if(success) {
                                network.getLikes(sub_id: "user") { error, success, result in
                                    if let error = error {
                                        print(error)
                                        return
                                    }
                                    
                                    if(success) {
                                        if let result = result {
                                            likes = result
                                            liked = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }, label: {
                Text("\(liked ? "Remove" : "Add")")
            })
        }
        .padding(.leading, 10).padding(.trailing, 20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Network())
    }
}
