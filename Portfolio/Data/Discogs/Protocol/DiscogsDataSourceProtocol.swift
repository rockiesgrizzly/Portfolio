//
//  DiscogsDataSourceProtocol.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

protocol DiscogsDataSourceProtocol {
    static func saveCredential(_ credential: DiscogsCredential) async throws
    static func retrieveCredential() async throws -> DiscogsCredential?
}
