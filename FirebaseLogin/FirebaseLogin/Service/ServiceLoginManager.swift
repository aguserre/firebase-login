//
//  ServiceManager.swift
//  FirebaseLogin
//
//  Created by Agustin Errecalde on 03/06/2021.
//
import Foundation
import FirebaseAuth
import FBSDKLoginKit

final class ServiceLoginManager {
    var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func login(provider: LoginMethod, delegate: UIViewController) {
        switch provider {
        case .facebook:
            facebookLogin()
        default:
            debugPrint("Not implemented")
        }
    }
    
    private func facebookLogin() {
        LoginManager().logIn(permissions: [.email], viewController: delegate) { result in
            switch result {
            case .success(granted: _, declined: _, token: let token):
                if let token = token?.tokenString {
                    self.tryloginWithFacebook(token: token)
                } else {
                    self.delegate?.presentAlertController(title: "Error", message: "An error ocurred. Try again later", completion: nil)
                }
            case .cancelled:
                if let vc = self.delegate as? LoginViewController {
                    vc.stopLoading()
                }
            case .failed(let error):
                self.delegate?.presentAlertController(title: "Error", message: error.localizedDescription, completion: { action in
                    self.logOut()
                })
            }
        }
    }
    
    private func tryloginWithFacebook(token: String) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential) { res, error in
            if let error = error {
                self.delegate?.presentAlertController(title: "Error", message: error.localizedDescription, completion: { action in
                    self.logOut()
                })
            }
            if let res = res, let vc = self.delegate as? LoginViewController {
                let userLogged = User(id: res.user.uid, name: res.user.displayName, image: res.user.photoURL?.absoluteString)
                vc.goToMain(userLogged: userLogged)
            }
        }
    }
    
    func fetchUserLoggedImage(completion: @escaping (UIImage?) -> Void) {
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"picture.width(480).height(480)"])
            
        graphRequest.start(completionHandler: { (connection, result, error) in
            if let res = result {
                DispatchQueue.main.async {
                    if let field = res as? [String:Any],
                       let imageURL = ((field["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String,
                       let url = URL(string: imageURL),
                       let data = NSData(contentsOf: url) {
                        completion(UIImage(data: data as Data))
                    } else {
                        completion(UIImage(named: "login-logo"))
                    }
                }
            } else {
                completion(UIImage(named: "login-logo"))
            }
        })
    }
    
    func logOut() {
        firebaseSignOut()
        facebooklogOut()
    }
    
    //Firebase logOut
    func firebaseSignOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    //Facebook logOut
    func facebooklogOut() {
        LoginManager().logOut()
    }
}
