//
//  PlacesServer.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public protocol PlacesServerDelegate {
    func getPlaces(for queryString: String?, in region: PlacesRegion?, range: Range<Int>?) -> PlacesList?
    func getPlacesCount() -> PlacesCount?
    func getPlacesIds(range: Range<Int>?) -> PlaceIdsList?
    func getPlacesTags() -> PlaceTagsList?
    func createPlace(_ place: Place) -> Place?
    func getPlace(for id: Place.PlaceIdType) -> Place?
    func updatePlace(for id: Place.PlaceIdType, with place: Place) -> Place?
    func removePlace(for id: Place.PlaceIdType) -> Place?
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

    public func getItems(_ query: [String:String]?, _ range: Range<Int>?) -> DataStoreContent? {
        let queryString = query?["name"]
        let region = placesRegion(from: query?["region"] ?? "")
        return delegate.getPlaces(for: queryString, in: region, range: range)
    }

    func createItem(_ content: DataStoreContent) -> DataStoreContent? {
        guard let place = content as? Place else { return nil }
        return delegate.createPlace(place)
    }

    func getItemsCount() -> DataStoreContent? {
        return delegate.getPlacesCount()
    }

    func getItemsIdentifiers( _ range: Range<Int>?) -> DataStoreContent? {
        return delegate.getPlacesIds(range: range)
    }

    func getItemsTags() -> DataStoreContent? {
        return delegate.getPlacesTags()
    }
    
    func getItem(_ itemId: String) -> DataStoreContent? {
        guard let placeId = Place.placeIdFromString(itemId) else { return nil }
        return delegate.getPlace(for: placeId)
    }

    func updateItem(_ itemId: String, _ content: DataStoreContent) -> DataStoreContent? {
        guard let placeId = Place.placeIdFromString(itemId) else { return nil }
        guard let place = content as? Place else { return nil }
        return delegate.updatePlace(for: placeId, with: place)
    }

    func deleteItem(_ itemId: String) -> DataStoreContent? {
        guard let placeId = Place.placeIdFromString(itemId) else { return nil }
        return delegate.removePlace(for: placeId)
    }

    func getEmptyItem() -> DataStoreContent? {
        return Place()
    }
}
