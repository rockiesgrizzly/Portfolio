//
//  DiscogsService.swift
//  Portfolio
//
//  Created by joshmac on 9/30/24.
//

import Foundation
import Networking


struct DiscogsService {
    private let baseUrl = "https://api.discogs.com/v1"
    private let remaining = "database/search?q={query}&{?type,title,release_title,credit,artist,anv,label,genre,style,country,year,format,catno,barcode,track,submitter,contributor}"
    
    func  search(query: String) {
        
    }
}
