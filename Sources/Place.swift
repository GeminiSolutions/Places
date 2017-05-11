//
//  Place.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

open class Place: DataStoreContentJSONDictionary<String,Any> {
    public typealias PlaceIdType = Int
    public typealias JSONObjectType = [String:Any]

    public var id: PlaceIdType?
    public var lastUpdate: Date?

    public var name: String? {
        get {
            return content["name"] as? String
        }
        set {
            set(newValue, for: "name")
        }
    }

    public var tags: [String]? {
        get {
            return content["tags"] as? [String]
        }
        set {
            set(newValue, for: "tags")
        }
    }

    public var latitude: Double? {
        get {
            return content["latitude"] as? Double
        }
        set {
            set(newValue, for: "latitude")
        }
    }

    public var longitude: Double? {
        get {
            return content["longitude"] as? Double
        }
        set {
            set(newValue, for: "longitude")
        }
    }

    public var coordinate: PlaceCoordinate2D? {
        get {
            guard let latitude = self.latitude, let longitude = self.longitude else { return nil }
            return PlaceCoordinate2D(latitude, longitude)
        }
        set {
            self.latitude = newValue?.latitude
            self.longitude = newValue?.longitude
        }
    }

    override public required init() {
        super.init()
    }

    public required init?(content: JSONObjectType) {
        guard Place.validate(content) else { return nil }
        super.init(json: content)
    }

    class public func placeIdFromString(_ string: String) -> PlaceIdType? {
        return PlaceIdType(string)
    }

    class public func stringFromPlaceId(_ placeId: PlaceIdType) -> String {
        return String(placeId)
    }
    
    class open func validate(_ json: JSONObjectType) -> Bool {
        guard json.keys.contains("name") else { return false }
        guard json.keys.contains("latitude") else { return false }
        guard json.keys.contains("longitude") else { return false }
        return true
    }

    class open var Fields: [[String:Any]] {
        return [["name":"name", "label": "Name", "type":"String", "required":"true"],
                ["name":"tags", "label": "Tags", "type":"Array<String>", "required":"false"],
                ["name":"latitude", "label" :"Latitude", "type":"Double", "required":"true"],
                ["name":"longitude", "label": "Longitude", "type":"Double", "required":"true"]]
    }
}
