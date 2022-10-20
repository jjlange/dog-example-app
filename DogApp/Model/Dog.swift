//
//  Dog.swift
//  DogApp
//
//  Created by Justin Lange on 18/10/2022.
//

import Foundation

struct Dog: Identifiable, Decodable {
    var id: Int
    var name: String
    var image: DogImage
}


struct DogImage: Decodable {
    var id: String
    var width: CGFloat
    var height: CGFloat
    var url: String
}
