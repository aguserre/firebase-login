//
//  Extension+UINavigationController.swift
//  FirebaseLogin
//
//  Created by Agustin Errecalde on 05/06/2021.
//

import UIKit


extension UINavigationController {
    
    func hide() {
        setNavigationBarHidden(true, animated: true)
    }
    
    func show() {
        setNavigationBarHidden(false, animated: true)
    }
    
    func setNavTitle(title: String) {
        let string = title
        let titleLbl = UILabel()
        let titleLblColor = UIColor.white
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: appFont, size: 15)!,
                                                         NSAttributedString.Key.foregroundColor: titleLblColor]
        titleLbl.attributedText = NSAttributedString(string: string, attributes: attributes)
        titleLbl.sizeToFit()
        
        navigationItem.titleView = titleLbl
    }
}
