//
//  DiscogsReleaseResponse.swift
//  Portfolio
//
//  Created by joshmac on 10/14/24.
//

import Foundation

// MARK: - Release
struct DiscogsReleaseResponse: Codable {
    let id: Int
    let status: String
    let year: Int
    let resourceUrl, uri: String
    let artists: [Artist]
    let artistsSort: String

    enum CodingKeys: String, CodingKey {
        case id, status, year
        case resourceUrl = "resource_url"
        case uri, artists
        case artistsSort = "artists_sort"
    }
    
    struct Artist: Codable {
        let name, anv, join, role: String
        let tracks: String
        let id: Int
        let resourceUrl: String

        enum CodingKeys: String, CodingKey {
            case name, anv, join, role, tracks, id
            case resourceUrl = "resource_url"
        }
    }
}
