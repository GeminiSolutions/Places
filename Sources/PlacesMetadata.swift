//
//  PlacesMetadata.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class PlacesMetadata: DataStoreContentJSONDictionary<String,Any> {
    public typealias JSONObjectType = [String:Any]

    public var tags: [String]? {
        get {
            return content["tags"] as? [String]
        }
        set {
            set(newValue, for: "tags")
        }
    }
}
