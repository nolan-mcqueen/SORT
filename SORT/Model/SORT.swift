
//
//  SORT.swift
//  SORT
//
//  Created by Nolan McQueen on 10/14/16.
//  Copyright © 2016 Nolan McQueen. All rights reserved.
//


import MapKit

class SORT: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        subtitle: String?,
        coordinate: CLLocationCoordinate2D)
    {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    // MARK: - Computed Properties
    
    /// POIs coodinates as a CLLocation object. Used for convenience in sorting functions.
    lazy var location: CLLocation = {
        return CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }()
    
    // Determine equality of POI instances. By default NSObject subclasses use memory location pointer as identity. We want the data to be considered identity so comparing two different instances of POI with identical data will be considered equal.
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? SORT else { return false }
        
        return self.title == other.title &&
            self.subtitle == other.subtitle &&
            self.coordinate.latitude == other.coordinate.latitude &&
            self.coordinate.longitude == other.coordinate.longitude
    }
    
    // Show descriptive text in console output. Useful during Unit Tests.
    override var description: String {
        return "\(title ?? ""): \(subtitle ?? "")"
    }
}
