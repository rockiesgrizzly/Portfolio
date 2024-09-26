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
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        return textField
    }()
    
    // MARK: - Lifecycle
    init(viewModel: GenAiViewModel, frame: CGRect = .zero) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        setupSubviews()
        update(with: viewModel)
    }

    required init?(coder: NSCoder) {
        assertionFailure("GenAiUiView init?(coder...) not implemented")
        return nil
    }
    
    // MARK: - Private
    private func setupSubviews() {
        textField.delegate = self
        
        addSubview(typeLabel)
        addSubview(topLabel)
        addSubview(textField)
        
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let margin: CGFloat = 24
        
        NSLayoutConstraint.activate([
            typeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            typeLabel.bottomAnchor.constraint(equalTo: topLabel.topAnchor, constant: -24),
            topLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -98),
            topLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin),
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -margin)
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
