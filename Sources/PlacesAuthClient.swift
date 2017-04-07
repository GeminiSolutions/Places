//
//  PlacesAuthClient.swift
//  Places
//
//  Copyright © 2017 Gemini Solutions. All rights reserved.
//

import Foundation
import DataStore

public class PlacesAuthClient {
    public typealias TokenBlock = (PlacesToken, Error?) -> Void

    private var dataStoreAuth: DataStoreAuthClient

    public init(transport: DataStoreClientTransport) {
        dataStoreAuth = DataStoreAuthClient(transport: transport, basePath: "/auth")
    }

    public func getAuthToken(for userName: String, _ password: String, completion: @escaping TokenBlock) {
        let authInfo = PlacesAuthInfo()
        authInfo.username = userName
        authInfo.password = password
        let token = PlacesToken()
        dataStoreAuth.createItem(authInfo, token) { (error) in
            completion(token, error)
        }
    }
}
