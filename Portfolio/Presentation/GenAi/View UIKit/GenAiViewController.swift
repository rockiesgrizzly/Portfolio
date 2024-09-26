//
//  GenAiViewController.swift
//  Portfolio
//
//  Created by joshmac on 9/25/24.
//

import UIKit

class GenAiViewController: UIViewController {
    
}

import SwiftUI

struct GenAiUiViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GenAiViewController {
        let viewController = GenAiViewController()
        // configuration if necessary
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: GenAiViewController, context: Context) {
        
    }
}
