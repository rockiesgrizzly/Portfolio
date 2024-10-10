//
//  DiscogsDataSourceProtocol.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

protocol DiscogsDataSourceProtocol {
    static func getAuthResponse(promptModel: DiscogsUserInfoModel) async throws -> DiscogsAuthResponseModel
}
