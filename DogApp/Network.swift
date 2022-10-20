//
//  Network.swift
//  DogApp
//
//  Created by Justin Lange on 18/10/2022.
//

import SwiftUI

class Network: ObservableObject {
    @Published var dogs: [Dog] = []
    @Published var likes: [Like] = []
    
    private var apiKey: String {
      get {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Info.plist'.")
        }

        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
        }
        return value
      }
    }
    
    func removeFavourite(id: Int, completion: @escaping ((Error?, Bool) -> Void)) {
        guard let url = URL(string: "https://api.thedogapi.com/v1/favourites/\(id)?api_key=\(apiKey)") else {
            print("Invalid URL")
            completion(nil, false)
            return
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = "DELETE"

        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                completion(error, false)
                return
            }
            
            completion(nil, true)
        }
        
        task.resume()
    }
    
    func addFavourite(image_id: String, sub_id: String, completion: @escaping ((Error?, Bool) -> Void)) {
        guard let url = URL(string: "https://api.thedogapi.com/v1/favourites?api_key=\(apiKey)") else {
            print("Invalid URL")
            completion(nil, false)
            return
        }
        
        let params = ["image_id": image_id,
                                   "sub_id": sub_id]
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField:"Content-Type")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            req.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }

        
        let task = URLSession.shared.dataTask(with: req) { (data, res, error) in
            if let error = error {
                completion(error, false)
                return
            }
            
            
            completion(nil, true)
        }

        task.resume()
    }
    
    
    func getDogs(completion: @escaping ((Error?, Bool, [Dog]?) -> Void)) {
        guard let url = URL(string: "https://api.thedogapi.com/v1/breeds") else {
            print("Invalid URL")
            completion(nil, false, nil)
            return
        }
        
        var req = URLRequest(url: url)
        req.setValue("x-api-key", forHTTPHeaderField: apiKey)
        
        let task = URLSession.shared.dataTask(with: req) { (data, res, error) in
            if let error = error {
                completion(error, false, nil)
                return
            }
            
            guard let data = data, let dogs = try? JSONDecoder().decode([Dog].self, from: data) else {
                completion(nil, false, nil)
                return
            }
            
            completion(nil, true, dogs)
        }
        
        task.resume()
    }
    
    func getLikes(sub_id: String, completion: @escaping ((Error?, Bool, [Like]?) -> Void)) {
        guard let url = URL(string: "https://api.thedogapi.com/v1/favourites?api_key=\(apiKey)&sub_id=\(sub_id)") else {
            print("Invalid URL")
            completion(nil, false, nil)
            return
        }
        
        let req = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: req) { (data, res, error) in
            if let error = error {
                completion(error, false, nil)
                return
            }
            
            guard let data = data, let dogs = try? JSONDecoder().decode([Like].self, from: data) else {
                completion(nil, false, nil)
                return
            }
            
            completion(nil, true, dogs)
        }
        
        task.resume()
    }
}
