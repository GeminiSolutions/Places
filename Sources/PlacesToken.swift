//
//  PlacesToken.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class PlacesToken: DataStoreContentJSONDictionary<String,Any> {
    public var token: String? {
        get {
            return content["token"] as? String
        }
        set {
            set(newValue, for: "token")
        }
    }
}
