//
//  PlaceData.swift
//  Snacktacular
//
//  Created by Mia Tortolani on 11/26/17.
//  Copyright © 2017 Mia Tortolani. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class PlaceData: NSObject, MKAnnotation {
    var placeName: String
    var address: String
    var postingUserID: String
    var coordinate: CLLocationCoordinate2D
    
    var title: String? {
        return placeName
    }
    
    var subtitle: String? {
        return address
    }
    
    init(placeName: String, address: String, coordinate: CLLocationCoordinate2D, postingUserID: String) {
        self.placeName = placeName
        self.address = address
        self.coordinate = coordinate
        self.postingUserID = postingUserID
    }
}
