//
//  PlacesCount.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class PlacesCount: DataStoreContentJSONDictionary<String,Int> {
    public var value: Int {
        get {
            return content["count"] ?? 0
        }
        set {
            set(newValue, for: "count")
        }
    }

    public override init() {
        super.init(json: ["count":0])
    }

    public init(count: Int) {
        super.init(json: ["count":count])
    }
}
