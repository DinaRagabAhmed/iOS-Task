//
//  UIViewControllerExtensions.swift
//  iOSTask
//
//  Created by Dina Ragab on 16/11/2022.
//

import UIKit

extension UIViewController {
    
    func makeActivityIndicator(size: CGSize) -> UIActivityIndicatorView {
        let style: UIActivityIndicatorView.Style = UIActivityIndicatorView.Style.medium
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.frame = .init(origin: .zero, size: size)
        
        return activityIndicator
    }
}
