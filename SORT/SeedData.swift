//
//  SeedData.swift
//  SORT
//
//  Created by Nolan McQueen on 2016-10-14.
//  Copyright © 2016 Nolan McQueen All rights reserved.
//

import CoreLocation

struct SeedData {
    
    /// Return new Array of test SORTs.
    static func makeSORTs() -> [SORT] {
        return [
            makeNolanSORT(),
            makeBenSORT(),
            makeWillSORT(),
            makeCatherineSORT(),
//            makeDarlenesSORT()
        ]
    }
    
    /// Return a new CLLocation with default values.
    static func makeLocation() -> CLLocation {
        return CLLocation(
            latitude: 49.85827,
            longitude: -97.157637
        )
    }
    
    // MARK: - Seed SORTs as static functions to make sorting easier.
    
    static func makeNolanSORT() -> SORT {
        return SORT(
            title: "Nolan McQueen",
            subtitle: "FU all the time!",
            coordinate: CLLocationCoordinate2D(
                latitude: 34.924799,
                longitude: -82.438284
            )
        )
    }
    
    static func makeBenSORT() -> SORT {
        return SORT(
            title: "Ben Hinson",
            subtitle: "FU 2018 | Louisville, KY",
            coordinate: CLLocationCoordinate2D(
                latitude: 34.924306,
                longitude: -82.440022
            )
        )
    }
    
    static func makeWillSORT() -> SORT {
        return SORT(
            title: "Will Stevens",
            subtitle: "Furman 2018 | KA",
            coordinate: CLLocationCoordinate2D(
                latitude: 34.925467,
                longitude: -82.439293
            )
        )
    }
    
    static func makeCatherineSORT() -> SORT {
        return SORT(
            title: "Catherine Luke",
            subtitle: "Tri Delt | Mtn Brook, AL",
            coordinate: CLLocationCoordinate2D(
                latitude: 34.924748,
                longitude:  -82.438265
            )
        )
    }
    
    static func makeDarlenesSORT() -> SORT {
        return SORT(
            title: "Darlene's Dumplings",
            subtitle: "Down right delicious Dumplings!",
            coordinate: CLLocationCoordinate2D(
                latitude: 49.8716259581715,
                longitude: -97.0682061864028
            )
        )
    }
    
    static func makeRandomSORTs(count: Int) -> [SORT] {
        let SORTs = (0..<count).map { _ in
            return makeRandomSORT()
        }
        
        return SORTs
    }
    
    static func makeRandomSORT() -> SORT {
        return SORT(
            title: "Randomly generated SORT",
            subtitle: "For Testing purposes only",
            coordinate: CLLocationCoordinate2D(
                latitude: Double.random(min: 49, max: 49.9),
                longitude: Double.random(min: -97, max: -98)
            )
        )
    }
}
