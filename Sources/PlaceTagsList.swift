//
//  PlaceTagsList.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class PlaceTagsList: DataStoreContentJSONArray<String> {
    public var placeTags: [String] {
        return content
    }

    public override init() {
        super.init()
    }

    public init(tags: [String]) {
        super.init(json: tags)
    }
}
