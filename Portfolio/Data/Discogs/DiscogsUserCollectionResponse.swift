//
//  DiscogsUserCollectionResponse.swift
//  Portfolio
//
//  Created by joshmac on 10/11/24.
//

struct DiscogsUserCollectionResponse: Codable {
    let releases: [Release]
    
    struct Release: Codable {
        let instanceId: Int
        let dateAdded: String
        let basicInformation: BasicInformation

        enum CodingKeys: String, CodingKey {
            case instanceId = "instance_id"
            case dateAdded = "date_added"
            case basicInformation = "basic_information"
        }
    }

    struct BasicInformation: Codable {
        let id, masterId: Int
        let masterUrl, title: String
        let year: Int?
        
        enum CodingKeys: String, CodingKey {
            case id, title, year
            case masterId = "master_id"
            case masterUrl = "master_url"
        }
    }

}

