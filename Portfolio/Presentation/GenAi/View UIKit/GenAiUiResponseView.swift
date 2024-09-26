//
//  GenAiUiResponseView.swift
//  Portfolio
//
//  Created by joshmac on 9/26/24.
//

import Combine
import UIKit

protocol GenAiUiResponseViewDelegate: AnyObject {
    func userDismissedView()
}

class GenAiUiResponseView: UIView {
    private weak var delegate: GenAiUiResponseViewDelegate?
    private var viewModel: GenAiViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    private let exitButton = {
        let image = UIImage(systemName: "xmark")
        let imageView = UIImageView(image: image)
        let button = UIButton()
        button.addSubview(imageView)
        return button
    }()
    
    private let responseTextView = {
        let textView = UITextView()
        textView.backgroundColor = .darkGray
        return textView
    }()
    

    // MARK: - Lifecycle
    init(viewModel: GenAiViewModel, delegate: GenAiUiResponseViewDelegate?, frame: CGRect = .zero) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(frame: frame)

        if let response = viewModel.response?.response {
            update(withResponse: response)
        }
        
        subscribeToPublishers()
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        assertionFailure("GenAiUiView init?(coder...) not implemented")
        return nil
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Internal
    func update(withResponse response: String) {
        self.responseTextView.text = response
    }
    
    // MARK: - Private
    private func subscribeToPublishers() {
        let response = viewModel.$response.sink { [weak self] response in
            guard let self, let response = response?.response, !response.isEmpty else { return }
            responseTextView.text = response
        }
        
        cancellables.insert(response)
    }
    
    private func setupSubviews() {
        addSubview(exitButton)
        addSubview(responseTextView)
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        responseTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let margin: CGFloat = 16
    
        NSLayoutConstraint.activate([
            exitButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            exitButton.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            exitButton.heightAnchor.constraint(equalToConstant: 16),
            exitButton.widthAnchor.constraint(equalToConstant: 16),
            responseTextView.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 32),
            responseTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            responseTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: margin),
            responseTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: margin)
        ])
        
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
    }
    
    @objc private func exitButtonTapped() {
        delegate?.userDismissedView()
    }

}
