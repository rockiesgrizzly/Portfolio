//
//  DiscogsDataSource.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

import Foundation

struct DiscogsDataSource: DiscogsDataSourceProtocol {
    static func getAuthResponse(promptModel: DiscogsUserInfoModel) async throws -> DiscogsAuthResponseModel {
        return DiscogsAuthResponseModel()
    }
}
 
