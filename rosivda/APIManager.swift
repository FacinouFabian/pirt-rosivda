//
//  APIManager.swift
//  rosivda
//
//  Created by Fabian on 22/04/2021.
//

import Foundation

class APIManager {
    
    static var shared = APIManager()
    static let ACCESS_TOKEN = "pk.56a2e12d5a8120bdc2b3a7dea87c0eaf&"
    private let baseURL = "https://eu1.locationiq.com/v1/search.php?key=\(ACCESS_TOKEN)"
    private let session = URLSession(configuration: .default)
    
    private func call<Data: Decodable>(_ path: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: "\(baseURL)&q=\(path)&format=json") else {
            completion(nil)
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let locations = try decoder.decode(Data.self, from: data)
                    DispatchQueue.main.async { completion(locations) }
                } catch (let error) {
                    print(error)
                    DispatchQueue.main.async { completion(nil) }
                    print("Deserialisation failed")
                }
            } else {
                DispatchQueue.main.async { completion(nil) }
                print("No data")
            }
        }

        task.resume()
    }
    
    func locations(search: String, completion: @escaping (Locations?) -> (Void)) {
        self.call(search, completion: completion)
    }
    
}
