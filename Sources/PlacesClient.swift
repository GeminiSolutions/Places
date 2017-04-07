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
    public typealias PlaceIdsBlock = ([Place.PlaceIdType], Error?) -> Void
    public typealias PlacesTagsBlock = ([String], Error?) -> Void

    private var dataStore: DataStoreClient

    private func query(from searchString: String, in region: PlacesRegion, tags: [String]) -> [String:String] {
        var query = [String:String]()
        query["name"] = searchString
        query["region"] = "\(region.northEast.latitude),\(region.northEast.longitude),\(region.southWest.latitude),\(region.southWest.longitude)"
        if tags.count > 0 { query["tags"] = tags.reduce("", { return ($0.isEmpty ? "" : $0+",") + $1 }) }
        return query
    }

    public init(transport: DataStoreClientTransport) {
        dataStore = DataStoreClient(transport: transport, basePath: "/places")
    }

    public func placesCount(completion: @escaping IntBlock) {
        let placesCount = PlacesCount()
        dataStore.getItemsCount(placesCount, { (error) in
            completion(placesCount.value, error)
        })
    }

    public func placesIds(range: Range<Int>?, completion: @escaping PlaceIdsBlock) {
        let placeIdsList = PlaceIdsList()
        dataStore.getItemsIdentifiers(range, placeIdsList, { (error) in
            completion(placeIdsList.placeIds, error)
        })
    }

    public func placesTags(completion: @escaping PlacesTagsBlock) {
        let placesMetadata = PlacesMetadata()
        dataStore.getItemsMetadata(placesMetadata, { (error) in
            completion(placesMetadata.tags ?? [], error)
        })
    }

    public func search(for searchString: String, in region: PlacesRegion, tags: [String], range: Range<Int>?, completion: @escaping PlacesBlock) {
        let placesList = PlacesList()
        dataStore.getItems(query(from: searchString, in: region, tags: tags), range, placesList, { (error) in
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

    public func update(place: Place, completion: @escaping PlaceBlock) {
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
