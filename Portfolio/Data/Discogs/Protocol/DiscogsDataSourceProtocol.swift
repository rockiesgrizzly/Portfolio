//
//  DiscogsDataSourceProtocol.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

protocol DiscogsDataSourceProtocol {
    static func saveRequestToken(_ token: String) async throws
    static func saveAccessToken(_ token: String) async throws
    static func saveAccessTokenSecret(_ token: String) async throws
    
    static func retrieveRequestToken() async throws -> String
    static func retrieveAccessToken() async throws -> String
    static func retrieveAccessTokenSecret() async throws -> String
}
