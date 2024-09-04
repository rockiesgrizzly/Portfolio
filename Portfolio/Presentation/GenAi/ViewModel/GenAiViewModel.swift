//
//  GenAiViewModel.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

import Foundation

@MainActor class GenAiViewModel: ObservableObject {
    @Published var userPromptText = ""
    var response: GenAiResponseEntryModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var userInvitationText: String {
        "How can artificial intelligence assist you?"
    }
    
    var promptDefaultText: String {
        "Enter your prompt here."
    }
    
    func userSubmittedPromptText() {
        Task {
            try await respond(toPrompt: userPromptText)
        }
    }
    
    func userExitedResponse() {
        userPromptText = ""
        response = nil
    }
    
    func respond(toPrompt prompt: String) async throws {
        isLoading = true

        let promptModel = GenAiPromptModel(prompt: prompt, service: .Gemini) // TODO: replace
        let result = try await GenAiGetUseCaseImplementation.execute(promptModel: promptModel)
        
        switch result {
        case .success(let response):
            self.response = response
        case .failure(let error):
            self.response = nil
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
