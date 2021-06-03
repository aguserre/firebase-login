//
//  LoginViewControllerViewModel.swift
//  FirebaseLogin
//
//  Created by Agustin Errecalde on 03/06/2021.
//
import UIKit

struct LoginViewControllerViewModel {
    
    enum LoginMethod {
        case facebook, phone, none
    }
    
    var loginMethod: LoginMethod {
        return .none
    }
    
    var faceboohLogoImage: UIImage? {
        return UIImage(named: "fb-logo")
    }
    
    var phoneLogoImage: UIImage? {
        let image = UIImage(systemName: "phone.fill")
        image?.withRenderingMode(.alwaysTemplate)
        return image
    }
    
    func setupButtonBackgroundColor(type: LoginMethod) -> UIColor {
        var backgroundColor: UIColor
        switch type {
        case .facebook:
            backgroundColor = .blue
        case .phone:
            backgroundColor = .systemIndigo
        default:
            backgroundColor = .clear
        }
        
        return backgroundColor
    }
    
    var backgroundColor: UIColor {
        return .white
    }
    
    var titleApp: String {
        return "iSocial Login"
    }
    
    var titleColor: UIColor {
        return .systemIndigo
    }
    
    var logoImage: UIImage? {
        return UIImage(named: "login-logo")
    }
    
}
