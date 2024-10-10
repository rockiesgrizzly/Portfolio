//
//  DiscogsService.swift
//  Portfolio
//
//  Created by joshmac on 9/30/24.
//

import Foundation
import Networking


struct DiscogsService {
    private let authUrl = "https://www.discogs.com/oauth/authorize"
    private let apiBaseUrl = "https://api.discogs.com"
    private let requestTokenUrlSuffix = "/oauth/request_token"
    private let accessTokenUrlSuffix = "/oauth/access_token"
    
    private static var apiKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "DISCOGS_KEY") as? String else { assertionFailure("No api key found. If you're testing this code, you'll need to grab an API key and drop it in Info.plist"); return "" }
        return apiKey
    }
    
    private static var apiSecret: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "DISCOGS_SECRET") as? String else { assertionFailure("No api secret found. If you're testing this code, you'll need to grab an API secret and drop it in Info.plist"); return "" }
        return apiKey
    }
    
    func authenticate() {
        
    }
}
