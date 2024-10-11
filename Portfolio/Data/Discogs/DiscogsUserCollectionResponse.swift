//
//  DiscogsUserCollectionResponse.swift
//  Portfolio
//
//  Created by joshmac on 10/11/24.
//

struct DiscogsUserCollectionResponse: Codable {
    let releases: [Release]
    
    struct Release: Codable {
        let instanceID: Int
        let dateAdded: String
        let basicInformation: BasicInformation

        enum CodingKeys: String, CodingKey {
            case instanceID = "instance_id"
            case dateAdded = "date_added"
            case basicInformation = "basic_information"
        }
    }

    struct BasicInformation: Codable {
        let id, masterID: Int
        let masterURL: String
        let title: String
        let year: Int?
        
        enum CodingKeys: String, CodingKey {
            case id
            case masterID = "master_id"
            case masterURL = "master_url"
            case title, year
        }
    }

}

