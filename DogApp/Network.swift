//
//  Network.swift
//  DogApp
//
//  Created by Justin Lange on 18/10/2022.
//

import SwiftUI

class Network: ObservableObject {
    @Published var dogs: [Dog] = []
    

    func getDogs() {
        guard let url = URL(string: "https://api.thedogapi.com/v1/breeds") else { fatalError("Missing API URL") }
        
        var req = URLRequest(url: url)
        req.setValue("x-api-key", forHTTPHeaderField: "INSERT API KEY HERE")
        
        let dataTask = URLSession.shared.dataTask(with: req) { (data, res, error) in
            if let error = error {
                print("API Request error:", error)
                return
            }
            
            guard let res = res as? HTTPURLResponse else { return }
            
            if(res.statusCode == 200) {
                do {
                    let decodedRes = try JSONDecoder().decode([Dog].self, from: data!)
                
                    DispatchQueue.main.async {
                        self.dogs = decodedRes
                    }
                } catch let error {
                    print("Error decoding response: ", error)
                }
            } else {
                print("Unsupported returned status code: ", res.statusCode)
            }
        }
        
        dataTask.resume()
    }
}
