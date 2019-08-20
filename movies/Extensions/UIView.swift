//
//  UIView.swift
//  movies
//
//  Created by Murilo Alves Alborghette on 8/19/19.
//  Copyright © 2019 Alborghette. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundCorners(withRadius radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
}
