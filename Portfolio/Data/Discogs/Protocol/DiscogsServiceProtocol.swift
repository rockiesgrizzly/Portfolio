//
//  DiscogsServiceProtocol.swift
//  Portfolio
//
//  Created by joshmac on 9/3/24.
//

import Foundation

protocol DiscogsServiceProtocol {
    static func response(toPrompt prompt: String) async throws -> String?
}
