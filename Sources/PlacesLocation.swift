//
//  PlacesLocation.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation

public struct PlaceCoordinate2D {
    public var latitude: Double
    public var longitude: Double
    
    public init(_ latitude: Double, _ longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public struct PlacesRegion {
    public var northEast: PlaceCoordinate2D
    public var southWest: PlaceCoordinate2D
    
    public init(_ northEast: PlaceCoordinate2D, _ southWest: PlaceCoordinate2D) {
        self.northEast = northEast
        self.southWest = southWest
    }
    
    public func contains(_ coordinate: PlaceCoordinate2D) -> Bool {
        return northEast.latitude ... southWest.latitude ~= coordinate.latitude && southWest.longitude ... northEast.longitude ~= coordinate.longitude
    }
}
