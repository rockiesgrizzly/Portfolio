//
//  GenAiUiContentView.swift
//  Portfolio
//
//  Created by joshmac on 9/25/24.
//

import Combine
import UIKit

class GenAiUiContentView: UIView {
    var viewModel: GenAiViewModel
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "UIKit"
        label.font = UIFont.italicSystemFont(ofSize: 12)
        return label
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let userTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        return textField
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    init(viewModel: GenAiViewModel, frame: CGRect = .zero) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        subscribeToPublishers()
        setupSubviews()
        update(with: viewModel)
    }

    required init?(coder: NSCoder) {
        assertionFailure("GenAiUiView init?(coder...) not implemented")
        return nil
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Private
    private func setupSubviews() {
        userTextField.delegate = self
        
        addSubview(typeLabel)
        addSubview(topLabel)
        addSubview(userTextField)
        
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let margin: CGFloat = 24
        
        NSLayoutConstraint.activate([
            typeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            typeLabel.bottomAnchor.constraint(equalTo: topLabel.topAnchor, constant: -24),
            topLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -98),
            topLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            userTextField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 24),
            userTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            userTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin),
            userTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            userTextField.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -margin)
        ])
    }
    
    private func update(with viewModel: GenAiViewModel) {
        topLabel.text = viewModel.userInvitationText
        userTextField.placeholder = viewModel.response?.response ?? viewModel.promptDefaultText
    }
    
    private func subscribeToPublishers() {
        let userPromptText = viewModel.$userPromptText.sink { [weak self] text in
            guard let self else { return }
            
            if let response = viewModel.response?.response {
                userTextField.text = response
            } else {
                userTextField.placeholder = viewModel.promptDefaultText
            }
        }
        
        cancellables.insert(userPromptText)
        
        let errorMessage = viewModel.$errorMessage.sink { [weak self] errorMessage in
            guard let self, let errorMessage, !errorMessage.isEmpty else { return }
            
            userTextField.text = errorMessage
        }
        
        cancellables.insert(errorMessage)
    }
}

extension GenAiUiContentView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField == userTextField, let prompt = textField.text else { return false }

        Task {
            try await viewModel.respond(toPrompt: prompt)
        }
        
        textField.resignFirstResponder()
        return true
    }
}
