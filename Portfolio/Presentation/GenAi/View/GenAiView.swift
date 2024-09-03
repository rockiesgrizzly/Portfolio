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
        VStack(alignment: .center, spacing: 16){
            Spacer()
            if viewModel.isLoading {
                ProgressView()
            } else {
                Text(viewModel.response?.response ?? viewModel.userInvitationText)
                TextField(viewModel.promptDefaultText, text: $viewModel.userPromptText)
                    .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
                    .onSubmit {
                        viewModel.userSubmittedPromptText()
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
