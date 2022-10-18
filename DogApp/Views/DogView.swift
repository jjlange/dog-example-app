//
//  DogView.swift
//  DogApp
//
//  Created by Justin Lange on 18/10/2022.
//

import SwiftUI

struct DogView: View {
    var dog: Dog
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: dog.image.url)){ image in                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
        }.navigationTitle(dog.name)
    }
}
