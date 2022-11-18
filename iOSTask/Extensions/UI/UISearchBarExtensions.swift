//
//  UISearchBarExtensions.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import Foundation
import UIKit

extension UISearchBar {
    
    func updateHeightAndCornerRadious(height: CGFloat, radius: CGFloat = 15.0) {
        let image: UIImage? = UIImage.imageWithColor(color: UIColor.white,
                                                     size: CGSize(width: 1, height: height))
        setSearchFieldBackgroundImage(image, for: .normal)
        for subview in self.subviews {
            for subSubViews in subview.subviews {
                for child in subSubViews.subviews {
                    if let textField = child as? UISearchTextField {
                        textField.layer.cornerRadius = radius
                        textField.clipsToBounds = true
                        textField.textAlignment = .left
                        textField.clearButtonMode = .whileEditing
                        textField.textColor = .black
                    }
                }
            }
        }
    }
}
