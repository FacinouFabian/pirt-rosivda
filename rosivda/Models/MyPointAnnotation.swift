//
//  MyPointAnnotation.swift
//  rosivda
//
//  Created by Fabian on 29/04/2021.
//

import Foundation
import UIKit
import MapKit

class MyPointAnnotation: MKPointAnnotation {
     var data: Location?

     init(location: Location?) {
        super.init()
        if let location = location {
            self.data = location
            self.title = location.display_name
            self.coordinate = CLLocationCoordinate2D(latitude: Double(location.lat)!, longitude: Double(location.lon)!)
        }
     }
}
