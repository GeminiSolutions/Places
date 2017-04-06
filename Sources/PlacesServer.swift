//
//  PlacesServer.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public protocol PlacesServerDelegate {
    func getPlaces(for queryString: String?, in region: (Double, Double, Double, Double)?, tags: [String]?, range: Range<Int>?) -> [Place.JSONObjectType]?
    func getPlacesCount() -> Int
    func getPlacesIds(range: Range<Int>?) -> [Place.PlaceIdType]?
    func getPlacesTags() -> [String]?
    func createPlace(content: Place.JSONObjectType) -> Place.JSONObjectType?
    func getPlace(for id: Place.PlaceIdType) -> Place.JSONObjectType?
    func updatePlace(for id: Place.PlaceIdType, with content: Place.JSONObjectType) -> Place.JSONObjectType?
    func removePlace(for id: Place.PlaceIdType) -> Place.JSONObjectType?
}

public class PlacesServer {
    private var dataStore: DataStoreServer

    public init(transport: DataStoreServerTransport, delegate: PlacesServerDelegate) {
        dataStore = DataStoreServer(transport: transport, delegate: DataStoreServerDelegateForPlaces(delegate: delegate))
    }
}

fileprivate class DataStoreServerDelegateForPlaces : DataStoreServerDelegate {
    private var delegate: PlacesServerDelegate

    fileprivate init(delegate: PlacesServerDelegate) {
        self.delegate = delegate
    }

    private func placesRegion(from string: String) -> PlacesRegion? {
        let components = string.components(separatedBy: ",")
        guard components.count == 4 else { return nil }
        guard let neLat = Double(components[0]), let neLong = Double(components[1]), let swLat = Double(components[2]), let swLong = Double(components[3]) else { return nil }
        return PlacesRegion(PlaceCoordinate2D(neLat, neLong), PlaceCoordinate2D(swLat, swLong))
    }

    private func placesTags(from string: String) -> [String]? {
        let components = string.components(separatedBy: ",")
        return components.isEmpty ? nil : components
    }

    public func getItems(_ query: [String:String]?, _ range: Range<Int>?) -> DataStoreContent? {
        let queryString = query?["name"]
        var regionData: (Double, Double, Double, Double)?
        if let regionString = query?["region"], let region = placesRegion(from: regionString) {
            regionData = (region.northEast.latitude, region.northEast.longitude, region.southWest.latitude, region.southWest.longitude)
        }
        var tags: [String]?
        if let tagsString = query?["tags"] {
            tags = placesTags(from: tagsString)
        }
        guard let places = delegate.getPlaces(for: queryString, in: regionData, tags: tags, range: range) else { return nil }
        return PlacesList(places: places)
    }

    func createItem(_ content: DataStoreContent) -> DataStoreContent? {
        guard let place = content as? Place else { return nil }
        guard let newPLace = delegate.createPlace(content: place.content) else { return nil }
        return Place(content: newPLace)
    }

    func getItemsMetadata() -> DataStoreContent? {
        guard let tags = delegate.getPlacesTags() else { return nil }
        let metadata = PlacesMetadata()
        metadata.tags = tags
        return metadata
    }
    
    func getItemsCount() -> DataStoreContent? {
        let count = delegate.getPlacesCount()
        guard count >= 0 else { return nil }
        return PlacesCount(count: count)
    }

    func getItemsIdentifiers( _ range: Range<Int>?) -> DataStoreContent? {
        guard let ids = delegate.getPlacesIds(range: range) else { return nil }
        return PlaceIdsList(ids: ids)
    }

    func getItem(_ itemId: String) -> DataStoreContent? {
        guard let placeId = Place.placeIdFromString(itemId) else { return nil }
        guard let place = delegate.getPlace(for: placeId) else { return nil }
        return Place(content: place)
    }

    func updateItem(_ itemId: String, _ content: DataStoreContent) -> DataStoreContent? {
        guard let placeId = Place.placeIdFromString(itemId) else { return nil }
        guard let place = content as? Place else { return nil }
        guard let newPlace = delegate.updatePlace(for: placeId, with: place.content) else { return nil }
        return Place(content: newPlace)
    }

    func deleteItem(_ itemId: String) -> DataStoreContent? {
        guard let placeId = Place.placeIdFromString(itemId) else { return nil }
        guard let place = delegate.removePlace(for: placeId) else { return nil }
        return Place(content: place)
    }

    func getEmptyItem() -> DataStoreContent? {
        return Place()
    }
}
