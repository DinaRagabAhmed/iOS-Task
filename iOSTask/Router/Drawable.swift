//
//  Drawable.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import UIKit

protocol Drawable {
    var viewController: UIViewController? { get }
}

extension UIViewController: Drawable {
    var viewController: UIViewController? { return self }
}
