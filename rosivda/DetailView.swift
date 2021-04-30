//
//  DetailViewController.swift
//  rosivda
//
//  Created by Fabian on 29/04/2021.
//

import Foundation
import UIKit

class DetailView: UIView {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var lon: UILabel!
    private var hide: Bool = true {
        didSet {
            self.isHidden = hide
        }
    }
    
    func initLabels(location: Location?) {	
        if let location = location {
            name.text = location.display_name
            lat.text = location.lat
            lon.text = location.lon
            self.handleDisplay()
        }
    }
    
    func handleDisplay(){
        self.hide = !hide
    }
}
