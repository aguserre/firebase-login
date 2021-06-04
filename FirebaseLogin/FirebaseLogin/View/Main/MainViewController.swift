//
//  MainViewController.swift
//  FirebaseLogin
//
//  Created by Agustin Errecalde on 03/06/2021.
//

import UIKit

final class MainViewController: UIViewController {
    
    var loginWithMethod: LoginMethod?
    var userLogged: User?

    private var viewModel: MainViewControllerViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainViewControllerViewModel(provider: loginWithMethod ?? .none)
        navigationItem.leftBarButtonItem = setupBackButton(target: #selector(logOut))
    }


    @objc private func logOut() {
        viewModel?.logOut(delegate: self)
    }
    
}
