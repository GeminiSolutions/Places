//
//  Place.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class Place: DataStoreContentJSONDictionary<String,Any> {
    public typealias PlaceIdType = Int
    public typealias JSONObjectType = [String:Any]

    public var id: PlaceIdType? {
        get {
            return content["id"] as? PlaceIdType
        }
        set {
            set(newValue, for: "id")
        }
    }

    public var name: String? {
        get {
            return content["name"] as? String
        }
        set {
            set(newValue!, for: "name")
        }
    }

    public var address: String? {
        get {
            return content["address"] as? String
        }
        set {
            set(newValue!, for: "address")
        }
    }

    public var url: String? {
        get {
            return content["url"] as? String
        }
        set {
            set(newValue!, for: "url")
        }
    }

    public var latitude: Double? {
        get {
            return content["latitude"] as? Double
        }
        set {
            set(newValue!, for: "latitude")
        }
    }
    
    public var longitude: Double? {
        get {
            return content["longitude"] as? Double
        }
        set {
            set(newValue!, for: "longitude")
        }
    }
    
    public override init() {
        super.init()
    }

    public init?(content: JSONObjectType) {
        guard Place.validate(content) else { return nil }
        super.init(json: content)
    }

    class public func validate(_ json: JSONObjectType) -> Bool {
        guard json.keys.contains("name") else { return false }
        guard json.keys.contains("latitude") else { return false }
        guard json.keys.contains("longitude") else { return false }
        return true
    }
}
