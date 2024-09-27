//
//  GenAiUiView.swift
//  Portfolio
//
//  Created by joshmac on 9/25/24.
//

import Combine
import UIKit

class GenAiUiView: UIView {
    var viewModel: GenAiViewModel {
        didSet {
            contentView.viewModel = viewModel
        }
    }
    
    private var activityIndicator = UIActivityIndicatorView()
    private lazy var contentView = GenAiUiContentView(viewModel: viewModel)
    private lazy var responseView = GenAiUiResponseView(viewModel: viewModel, delegate: self)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    init(viewModel: GenAiViewModel, frame: CGRect = .zero) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        subscribeToPublishers()
        setupUI()
    }
    required init?(coder: NSCoder) {
        assertionFailure("GenAiUiView init?(coder...) not implemented")
        return nil
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Internal
    func showActivity(_ show: Bool) {
        UIView.animate(withDuration: 0.25) {
            if show {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                self.responseView.isHidden = true
                self.contentView.isHidden = true
            } else {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                
                if let response = self.viewModel.response?.response, !response.isEmpty {
                    self.responseView.update(withResponse: response)
                    self.responseView.isHidden = false
                    self.contentView.isHidden = true
                } else {
                    self.responseView.isHidden = true
                    self.contentView.isHidden = false
                }
            }
        }
    }

    // MARK: - Private - Setup
    private func subscribeToPublishers() {
            let isLoading = viewModel.$isLoading.sink { [weak self] isLoading in
                guard let self else { return }
                showActivity(isLoading)
            }
        
            cancellables.insert(isLoading)
    }
    
    private func setupUI() {
        addSubview(activityIndicator)
        addSubview(contentView)
        addSubview(responseView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        responseView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            responseView.topAnchor.constraint(equalTo: topAnchor),
            responseView.leadingAnchor.constraint(equalTo: leadingAnchor),
            responseView.trailingAnchor.constraint(equalTo: trailingAnchor),
            responseView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension GenAiUiView: GenAiUiResponseViewDelegate {
    func userDismissedView() {
        responseView.isHidden = true
        contentView.isHidden = false
        viewModel.userExitedResponse()
    }
}
