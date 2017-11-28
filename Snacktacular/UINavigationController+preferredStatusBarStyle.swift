//
//  UINavigationController+preferredStatusBarStyle.swift
//  Snacktacular
//
//  Created by Mia Tortolani on 11/27/17.
//  Copyright © 2017 Mia Tortolani. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
}
