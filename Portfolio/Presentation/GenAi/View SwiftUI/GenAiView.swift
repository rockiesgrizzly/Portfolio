//
//  GenAiView.swift
//  Portfolio
//
//  Created by joshmac on 9/2/24.
//

import SwiftUI

struct GenAiView: View {
    @StateObject var viewModel = GenAiViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 24){
            if viewModel.isLoading {
                Spacer()
                ProgressView()
            } else if viewModel.response?.response == nil {
                Spacer()
                Text("SwiftUI with Gemini API")
                    .font(Font(UIFont.italicSystemFont(ofSize: 12)))
                Text(viewModel.userInvitationText)
                TextField(viewModel.promptDefaultText, text: $viewModel.userPromptText)
                    .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
                    .onSubmit {
                        viewModel.userSubmittedPromptText()
                    }
                Spacer()
            } else if let response = viewModel.response?.response {
                Button(action: {
                    viewModel.userExitedResponse()
                }) {
                    Image(systemName: "xmark")
                }
                List {
                    Text(response)
                }
            }
            
            Spacer()
        }
    }
    
}

struct GenAiView_Previews: PreviewProvider {
    static var previews: some View {
        GenAiView()
            .preferredColorScheme(.dark)
    }
}
