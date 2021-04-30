//
//  Locations.swift
//  rosivda
//
//  Created by Fabian on 22/04/2021.
//

import Foundation

typealias Locations = [Location]

struct Location: Decodable {
    let place_id: String
    let lat: String
    let lon: String
    let display_name: String
}
