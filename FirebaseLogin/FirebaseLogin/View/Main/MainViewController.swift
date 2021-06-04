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
    private var viewModel = MainViewControllerViewModel()
    

    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var yearsTextField: UITextField!
    @IBOutlet private weak var birthDayTextField: UITextField!
    @IBOutlet private weak var stackTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nameTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var newClientLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }


    @objc private func logOut() {
        viewModel.logOut(delegate: self)
    }
    
    @objc func keyboardWillAppear() {
        UIView.animate(withDuration: 1) {
            self.stackTopConstraint.constant = 30
            self.userImage.isHidden = true
            self.nameTopConstraint.constant = 20
            self.newClientLabel.isHidden = true
            self.userNameLabel.text = "New client"
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillDisappear() {
        UIView.animate(withDuration: 1) {
            self.stackTopConstraint.constant = 160
            self.nameTopConstraint.constant = 120
            self.newClientLabel.isHidden = false
            self.userNameLabel.text = self.userLogged?.name
            self.view.layoutIfNeeded()
        } completion: { finish in
            self.userImage.isHidden = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupView() {
        navigationItem.leftBarButtonItem = setupBackButton(target: #selector(logOut))
        ImageDownloader().downloadImage(url: userLogged?.image ?? "", completion: { image in
            self.userImage.image = image
            self.userImage.roundCorner(shadow: true)
        })
        userNameLabel.text = userLogged?.name
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        //Validate user
    }
    
}
