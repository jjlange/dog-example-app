//
//  FavouriteView.swift
//  DogApp
//
//  Created by Justin Lange on 19/10/2022.
//

import SwiftUI

struct FavouriteView: View {
    @EnvironmentObject var network: Network
    @State var likes = [Like]()
    @State var dogs = [Dog]()
    
    let layout = Array(repeating: GridItem(.adaptive(minimum:50)), count: 4)
    
    var body: some View {
        ScrollView {
            if(!dogs.isEmpty) {
                if(!likes.isEmpty) {
                    LazyVGrid(columns: layout, spacing: 20){
                        ForEach(likes) { like in
                            NavigationLink(destination: DogView(dog: dogs.filter{ $0.image.id == like.image_id }.first!)) {
                                AsyncImage(url: URL(string: dogs.filter{ $0.image.id == like.image_id }.first!.image.url)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }.padding()
                } else {
                    Text("No favourites. Add some under 'List'.").font(.title2)
                }
            } else {
                ProgressView()
            }
        }.onAppear() {
            Task {
                network.getLikes(sub_id: "user") { error, success, result in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    if(success) {
                        likes = result!
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
                    }
                }
            }
        }
        .navigationTitle("Favourites")
    }
}
