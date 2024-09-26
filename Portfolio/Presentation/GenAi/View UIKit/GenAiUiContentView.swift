//
//  GenAiUiContentView.swift
//  Portfolio
//
//  Created by joshmac on 9/25/24.
//

import UIKit

class GenAiUiContentView: UIView {
    var viewModel: GenAiViewModel {
        didSet {
            update(with: viewModel)
        }
    }
    
    private let topLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    // MARK: - Lifecycle
    init(viewModel: GenAiViewModel, frame: CGRect = .zero) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        assertionFailure("GenAiUiView init?(coder...) not implemented")
        return nil
    }
    
    // MARK: - Private
    private func setupSubviews() {
        textField.delegate = self
        
        addSubview(topLabel)
        addSubview(textField)
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            topLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            topLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: 16),
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func update(with viewModel: GenAiViewModel) {
        topLabel.text = viewModel.userInvitationText
        textField.placeholder = viewModel.promptDefaultText
    }
}

extension GenAiUiContentView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let prompt = textField.text else { return }
        Task {
            try await viewModel.respond(toPrompt: prompt)
        }
    }
}
