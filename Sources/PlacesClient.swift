//
//  PlacesClient.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public enum PlacesClientError: Error {
    case invalidPlaceId
}

public class PlacesClient {
    public typealias ErrorBlock = (Error?) -> Void
    public typealias IntBlock = (Int, Error?) -> Void
    public typealias PlaceBlock = (Place, Error?) -> Void
    public typealias PlacesBlock = ([Place], Error?) -> Void

    private var dataStore: DataStoreClient

    private func query(from searchString: String, in region: PlacesRegion) -> [String:String] {
        let query = ["name":searchString, "region":"\(region.northEast.latitude),\(region.northEast.longitude),\(region.southWest.latitude),\(region.southWest.longitude)"]
        return query
    }

    public init(transport: DataStoreClientTransport) {
        dataStore = DataStoreClient(transport: transport)
    }

    public func placesCount(completion: @escaping IntBlock) {
        let placesCount = PlacesCount()
        dataStore.getItemsCount(placesCount, { (error) in
            completion(placesCount.value, error)
        })
    }

    public func search(for searchString: String, in region: PlacesRegion, range: Range<Int>?, completion: @escaping PlacesBlock) {
        let placesList = PlacesList()
        dataStore.getItems(query(from: searchString, in: region), range, placesList, { (error) in
            completion(placesList.places, error)
        })
    }

    public func add(place: Place, completion: @escaping PlaceBlock) {
        let newPlace = Place()
        dataStore.createItem(place, newPlace, { (metadata, error) in
            completion(newPlace, error)
        })
    }

    public func getPlace(with placeId: Place.PlaceIdType, completion: @escaping PlaceBlock) {
        let place = Place()
        guard let itemId = Place.stringFromPlaceId(placeId) else {
            completion(place, PlacesClientError.invalidPlaceId)
            return
        }
        dataStore.getItem(id: itemId, place, { (metadata, error) in
            completion(place, error)
        })
    }

    public func update(_ place: Place, completion: @escaping PlaceBlock) {
        let newPlace = Place()
        guard let placeId = place.id, let itemId = Place.stringFromPlaceId(placeId) else {
            completion(newPlace, PlacesClientError.invalidPlaceId)
            return
        }
        dataStore.updateItem(id: itemId, place, newPlace, { (error) in
            completion(newPlace, error)
        })
    }

    public func remove(placeId: Place.PlaceIdType, completion: @escaping ErrorBlock) {
        guard let itemId = Place.stringFromPlaceId(placeId) else {
            completion(PlacesClientError.invalidPlaceId)
            return
        }
        dataStore.removeItem(id: itemId, { (error) in
            completion(error)
        })
    }
}
