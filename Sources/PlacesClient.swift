//
//  PlacesClient.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class PlacesClient {
    public typealias ErrorBlock = (Error?) -> Void
    public typealias IntBlock = (Int, Error?) -> Void
    public typealias PlaceBlock = (Place, Error?) -> Void
    public typealias PlacesBlock = ([Place], Error?) -> Void
    
    private var dataStore: DataStoreClient
    
    private func query(from searchString: String, in region: PlacesRegion) -> [String:Any] {
        let query = ["name":searchString, "region":"\(region.northEast.latitude),\(region.northEast.longitude),\(region.southWest.latitude),\(region.southWest.longitude)"]
        return query
    }
    
    public init(transport: DataStoreClientTransport) {
        dataStore = DataStoreClient(transport: transport)
    }
    
    public func add(place: Place, completion: @escaping PlaceBlock) {
        let newPlace = Place()
        dataStore.createItem(place, newPlace, { (metadata, error) in
            completion(newPlace, error)
        })
    }
    
    public func remove(place: Place, completion: @escaping ErrorBlock) {
        dataStore.removeItem(id: "\(place.id)") { (error) in
            completion(error)
        }
    }
    
    public func placesCount(completion: @escaping IntBlock) {
        let placesCount = PlacesCount()
        dataStore.getItemsCount(placesCount, { (error) in
            completion(placesCount.value, error)
        })
    }
    
    public func search(for searchString: String, in region: PlacesRegion, completion: @escaping PlacesBlock) {
        let placesList = PlacesList()
        dataStore.getItems(query(from: searchString, in: region), nil, placesList, { (error) in
            completion(placesList.places, error)
        })
    }
}
