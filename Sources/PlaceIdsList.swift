//
//  PlaceIdsList.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class PlaceIdsList: DataStoreContentJSONArray<Place.PlaceIdType> {
    public var placeIds: [Place.PlaceIdType] {
        return content
    }

    public override init() {
        super.init()
    }

    public init(ids: [Place.PlaceIdType]) {
        super.init(json: ids)
    }
}
