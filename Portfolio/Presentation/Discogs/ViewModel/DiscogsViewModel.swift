//
//  DiscogsViewModel.swift
//  Portfolio
//
//  Created by joshmac on 10/11/24.
//

import Foundation

@MainActor
class DiscogsViewModel: ObservableObject {
    var collection: DiscogsReleasesCollection?
    
    init() async throws {
        let _ = try await DiscogsRequestTokenUseCaseImplementation.execute()
    }
}
