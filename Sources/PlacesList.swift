//
//  PlacesList.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class PlacesList: DataStoreContentJSONArray<[String:Any]> {
    public override init() {
        super.init()
    }

    public init(placesData: [(place: Place.JSONObjectType, id: Place.PlaceIdType, lastUpdate: Date)]) {
        let places = placesData.map({ return ["content":$0.place, "id":Place.stringFromPlaceId($0.id), "lastUpdate":PlacesList.dateString(from: $0.lastUpdate)] })
        super.init(json: places)
    }

    public func places<PlaceType: Place>() -> [PlaceType] {
        var places: [PlaceType] = []
        content.forEach {
            if let place: PlaceType = place(from: $0) { places.append(place) }
        }
        return places
    }

    public func place<PlaceType: Place>(for id: Place.PlaceIdType) -> PlaceType? {
        for data in content {
            if let idStr = data["id"] as? String, let placeId = Place.placeIdFromString(idStr), placeId == id {
                return place(from: data)
            }
        }
        return nil
    }

    public func append(place: Place) {
        guard let id = place.id, let lastUpdate = place.lastUpdate else { return }
        append(["content":place.content, "id":Place.stringFromPlaceId(id), "lastUpdate":PlacesList.dateString(from: lastUpdate)])
    }

    private func place<PlaceType: Place>(from data: [String:Any]) -> PlaceType? {
        guard let content = data["content"] as? Place.JSONObjectType, let id = data["id"] as? String, let lastUpdate = data["lastUpdate"] as? String else { return nil }
        guard let placeId = Place.placeIdFromString(id), let placeLastUpdate = PlacesList.date(from: lastUpdate) else { return nil }
        guard let place = PlaceType(content: content) else { return nil }
        place.id = placeId
        place.lastUpdate = placeLastUpdate
        return place
    }
}
