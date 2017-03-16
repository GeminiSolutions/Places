//
//  PlacesList.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class PlacesList: DataStoreContentJSONArray<Place.JSONObjectType> {
    var places: [Place] {
        var places: [Place] = []
        content.forEach {
            guard let place = Place(content: $0) else { return }
            places.append(place)
        }
        return places
    }

    public func place(for id: Place.PlaceIdType) -> Place? {
        for placeContent in content {
            guard let place = Place(content: placeContent) else { continue }
            guard place.id != id else { return place }
        }
        return nil
    }

    public func append(place: Place) {
        append(place.content)
    }

    public func remove(place: Place) {
        guard let id = place.id else { return }
        remove(placeWithId: id)
    }

    public func remove(placeWithId id: Place.PlaceIdType) {
        if let index = content.index(where: {
            guard let place = Place(content: $0) else { return false }
            return place.id == id
        }) { remove(at: index) }
    }
}
