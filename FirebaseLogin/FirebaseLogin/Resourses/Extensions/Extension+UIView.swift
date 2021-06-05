//
//  Extension+UIView.swift
//  FirebaseLogin
//
//  Created by Agustin Errecalde on 05/06/2021.
//

import UIKit


extension UIView {
    
    func addShadow(offset: CGSize = .zero, color: UIColor = .systemIndigo, radius: CGFloat = 7, opacity: Float = 0.5) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
    func roundCorner(radius: CGFloat? = nil, shadow: Bool = false) {
        layer.cornerRadius = radius ?? 5
        clipsToBounds = true
        if shadow {
            addShadow()
        }
    }
    
}
