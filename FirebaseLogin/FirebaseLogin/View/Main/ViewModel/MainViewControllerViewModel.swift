//
//  MainViewControllerViewModel.swift
//  FirebaseLogin
//
//  Created by Agustin Errecalde on 03/06/2021.
//

import UIKit

struct MainViewControllerViewModel {
    
    let provider: LoginMethod
    
    init(provider: LoginMethod) {
        self.provider = provider
    }
        
    func logOut(delegate: UIViewController) {
        delegate.presentAlertControllerWithCancel(title: "Wait!", message: "Are you sure to close session?") { action in
            let serviceLoginManager = ServiceLoginManager(delegate: delegate)
            serviceLoginManager.firebaseSignOut()
            serviceLoginManager.facebooklogOut()
            DispatchQueue.main.async {
                delegate.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
}
