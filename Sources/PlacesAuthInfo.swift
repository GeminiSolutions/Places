//
//  PlacesAuthInfo.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class PlacesAuthInfo: DataStoreContentJSONDictionary<String,Any> {
    public var username: String? {
        get {
            return content["username"] as? String
        }
        set {
            set(newValue, for: "username")
        }
    }

    public var password: String? {
        get {
            return content["password"] as? String
        }
        set {
            set(newValue, for: "password")
        }
    }
}
