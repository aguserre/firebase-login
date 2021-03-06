//
//  LoginViewController.swift
//  FirebaseLogin
//
//  Created by Agustin Errecalde on 03/06/2021.
//

import UIKit

final class LoginViewController: UIViewController {

    //Outlets
    @IBOutlet private weak var titleAppLabel: UILabel!
    @IBOutlet private weak var logoImage: UIImageView!
    @IBOutlet private weak var facebookButton: UIButton!
    @IBOutlet private weak var facebookIconImage: UIImageView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    
    //Properties
    private let viewModel = LoginViewControllerViewModel()
    var isInitialView = true

    //Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        setupView(activeUser: viewModel.isUserActive)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hide()
        if !isInitialView {
            setupView(activeUser: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.show()
    }

    private func setupView(activeUser: Bool) {
        titleAppLabel.text = viewModel.titleApp
        titleAppLabel.textColor = viewModel.titleColor
        logoImage.image = viewModel.logoImage
        facebookButton.isHidden = activeUser
        facebookIconImage.isHidden = activeUser
        if activeUser {
            setupViewWithCurrentUser()
        } else {
            setupDefaultView()
        }
    }
    
    private func setupDefaultView() {
        facebookButton.backgroundColor = viewModel.setupButtonBackgroundColor(type: .facebook)
        facebookButton.roundCorner(shadow: true)
        facebookIconImage.image = viewModel.faceboohLogoImage
        stopLoading()
    }
    
    private func setupViewWithCurrentUser() {
        if let user = viewModel.userLogged {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.goToMain(userLogged: user)
            }
        } else {
            setupDefaultView()
        }
    }

    @IBAction func facebookTapped(_ sender: UIButton) {
        generateImpactWhenTouch()
        startLoading()
        viewModel.login(provider: .facebook, delegate: self)
    }
    
    func goToMain(userLogged: User) {
        isInitialView = false
        let mainVC = MainViewController()
        mainVC.userLogged = userLogged
        stopLoading()
        navigationController?.pushViewController(mainVC, animated: true)
    }
    
    func startLoading() {
        loader.startAnimating()
        facebookButton.isEnabled = false
    }
    
    func stopLoading() {
        loader.stopAnimating()
        facebookButton.isEnabled = true
    }
    
}
