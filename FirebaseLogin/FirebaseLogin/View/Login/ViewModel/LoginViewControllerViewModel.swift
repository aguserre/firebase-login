//
//  LoginViewControllerViewModel.swift
//  FirebaseLogin
//
//  Created by Agustin Errecalde on 03/06/2021.
//
import UIKit
import FirebaseAuth

enum LoginMethod {
    case facebook, none
}

struct LoginViewControllerViewModel {
    
    var faceboohLogoImage: UIImage? {
        return UIImage(named: "logo-fb")
    }
    
    var userLogged: User? {
        if let user = Auth.auth().currentUser {
            return User(id: user.uid, name: user.displayName, image: user.photoURL?.absoluteString)
        } else {
            return nil
        }
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
        return "My Clients APP"
    }
    
    var titleColor: UIColor {
        return .systemIndigo
    }
    
    var logoImage: UIImage? {
        return UIImage(named: "login-logo")
    }
    
    var isUserActive: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func login(provider: LoginMethod, delegate: UIViewController) {
        ServiceLoginManager(delegate: delegate).login(provider: provider, delegate: delegate)
    }
    
}
