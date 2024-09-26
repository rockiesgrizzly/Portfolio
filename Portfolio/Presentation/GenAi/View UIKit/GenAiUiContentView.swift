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
    private func update(with viewModel: GenAiViewModel) {
        
    }
}

