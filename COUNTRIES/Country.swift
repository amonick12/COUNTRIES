//
//  Country.swift
//  COUNTRIES
//
//  Created by Aaron Monick on 8/18/15.
//  Copyright (c) 2015 MONIX. All rights reserved.
//

import Foundation
import MapKit

class Country: NSObject, MKAnnotation {
    
    let id: String
    let title: String
    let name: String
    let capital: String
    let long: CLLocationDegrees?
    let lat: CLLocationDegrees?
    let coordinate: CLLocationCoordinate2D
    
    init(id: String, name: String, capital: String, long: String, lat: String) {
        self.id = id
        self.name = name
        self.title = name
        self.capital = capital
        if let longVal = NSNumberFormatter().numberFromString(long), let latVal = NSNumberFormatter().numberFromString(lat) {
            self.long = longVal.doubleValue
            self.lat = latVal.doubleValue
            self.coordinate = CLLocationCoordinate2DMake(self.lat!, self.long!)
        } else {
            self.long = nil
            self.lat = nil
            self.coordinate = CLLocationCoordinate2D()
        }
        
        super.init()
    }
    
    var subtitle: String {
        return capital
    }
}