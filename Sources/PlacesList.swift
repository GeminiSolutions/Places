//
//  PlacesList.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class PlacesList: DataStoreContentJSONArray<[String:Any]> {
    public var places: [Place] {
        var places: [Place] = []
        content.forEach {
            if let place = place(from: $0) { places.append(place) }
        }
        return places
    }

    public override init() {
        super.init()
    }

    public init(placesData: [(place: Place.JSONObjectType, id: Place.PlaceIdType, lastUpdate: Date)]) {
        let places = placesData.map({ return ["place":$0.place, "id":Place.stringFromPlaceId($0.id), "lastUpdate":DataStore.dateString(from: $0.lastUpdate)] })
        super.init(json: places)
    }

    public func place(for id: Place.PlaceIdType) -> Place? {
        for data in content {
            if let idStr = data["id"] as? String, let placeId = Place.placeIdFromString(idStr), placeId == id {
                return place(from: data)
            }
        }
        return nil
    }

    public func append(place: Place) {
        guard let id = place.id, let lastUpdate = place.lastUpdate else { return }
        append(["place":place.content, "id":Place.stringFromPlaceId(id), "lastUpdate":DataStore.dateString(from: lastUpdate)])
    }

    private func place(from data: [String:Any]) -> Place? {
        guard let content = data["place"] as? Place.JSONObjectType, let id = data["id"] as? String, let lastUpdate = data["lastUpdate"] as? String else { return nil }
        guard let placeId = Place.placeIdFromString(id), let placeLastUpdate = DataStore.date(from: lastUpdate) else { return nil }
        guard let place = Place(content: content) else { return nil }
        place.id = placeId
        place.lastUpdate = placeLastUpdate
        return place
    }
}
