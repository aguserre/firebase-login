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
    @IBOutlet private weak var stackTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nameTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var newClientLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupView()
        addPickerTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.addKeyboardObservers(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.removeKeyboardObservers(self)
    }


    @objc private func logOut() {
        viewModel.logOut(delegate: self)
    }
    
    private func addPickerTarget() {
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        viewModel.dateSelected = sender.date
    }
    
    @objc func keyboardWillAppear() {
        animateView(expand: true)
    }

    @objc func keyboardWillDisappear() {
        animateView(expand: false)
    }

    private func hideViews(_ hide: Bool) {
        userImage.isHidden = hide
        newClientLabel.isHidden = hide
    }
    
    private func animateView(expand: Bool) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1) {
            self.hideViews(expand ? true : false)
            self.stackTopConstraint.constant = expand ? self.viewModel.topConstraintCompress : self.viewModel.topConstraintExpanded
            self.nameTopConstraint.constant = expand ? self.viewModel.nameConstraintCompress : self.viewModel.nameConstraintExpanded
            self.userNameLabel.text = expand ? self.viewModel.newClientText : self.userLogged?.name
            self.view.layoutIfNeeded()
        }
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
        if let nameText = nameTextField.text {
            if !viewModel.isValidData(dataString: nameText, type: .name) {
                nameTextField.textColor = viewModel.errorColor
            } else {
                nameTextField.textColor = viewModel.defaultColor
            }
        }
        if let lastNameText = lastNameTextField.text {
            if !viewModel.isValidData(dataString: lastNameText, type: .lastName) {
                lastNameTextField.textColor = viewModel.errorColor
            } else {
                lastNameTextField.textColor = viewModel.defaultColor
            }
        }
        if let years = yearsTextField.text {
            viewModel.client.years = Int(years)
        }
        if !viewModel.isValidData(date: viewModel.dateSelected, type: .birthday) {
            datePicker.tintColor = viewModel.errorColor
        } else {
            viewModel.client.birthDate = viewModel.dateSelected.toString()
            datePicker.tintColor = viewModel.defaultColor
        }
            
        if !viewModel.errors.isEmpty {
            viewModel.presentDataErrorsMessage(delegate: self)
        } else {
            viewModel.saveUser(delegate: self, id: userLogged?.id)
            DispatchQueue.main.async {
                self.clearData()
            }
        }
    }
    
    private func clearData() {
        nameTextField.text = ""
        lastNameTextField.text = ""
        yearsTextField.text = ""
    }
    
}
