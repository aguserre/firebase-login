//
//  LoginViewController.swift
//  FirebaseLogin
//
//  Created by Agustin Errecalde on 03/06/2021.
//

import UIKit

final class LoginViewController: UIViewController {

    //Outlets
    @IBOutlet weak var titleAppLabel: UILabel!
    @IBOutlet private weak var logoImage: UIImageView!
    @IBOutlet private weak var facebookButton: UIButton!
    @IBOutlet private weak var facebookIconImage: UIImageView!
    
    
    //Properties
    private let viewModel = LoginViewControllerViewModel()

    //Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupView() {
        view.backgroundColor = viewModel.backgroundColor
        titleAppLabel.text = viewModel.titleApp
        titleAppLabel.textColor = viewModel.titleColor
        logoImage.image = viewModel.logoImage
        facebookButton.backgroundColor = viewModel.setupButtonBackgroundColor(type: .facebook)
        facebookButton.roundCorner()
        facebookButton.addShadow()
        facebookIconImage.image = viewModel.faceboohLogoImage
        facebookIconImage.addShadow()
    }

    @IBAction func facebookTapped(_ sender: UIButton) {
        viewModel.login(provider: .facebook, delegate: self)
    }
    
    func goToMain(userLogged: User) {
        let mainVC = MainViewController()
        mainVC.userLogged = userLogged
        navigationController?.pushViewController(mainVC, animated: true)
    }
    
}
