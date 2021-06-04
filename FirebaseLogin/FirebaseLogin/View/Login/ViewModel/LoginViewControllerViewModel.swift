//
//  LoginViewControllerViewModel.swift
//  FirebaseLogin
//
//  Created by Agustin Errecalde on 03/06/2021.
//
import UIKit

enum LoginMethod {
    case facebook, none
}

struct LoginViewControllerViewModel {
    
    var faceboohLogoImage: UIImage? {
        return UIImage(named: "logo-fb")
    }
    
    func setupButtonBackgroundColor(type: LoginMethod) -> UIColor {
        var backgroundColor: UIColor
        switch type {
        case .facebook:
            backgroundColor = .blue
        default:
            backgroundColor = .systemIndigo
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
    
    func login(provider: LoginMethod, delegate: UIViewController) {
        ServiceLoginManager(delegate: delegate).login(provider: provider, delegate: delegate)
    }
    
}
