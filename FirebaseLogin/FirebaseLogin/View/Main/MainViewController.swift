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
    var viewModel = MainViewControllerViewModel()

    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var yearsTextField: UITextField!
    @IBOutlet private weak var stackTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nameTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var newClientLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupView()
        setupTextFieldsDelegate()
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
        generateImpactWhenTouch()
        viewModel.logOut(delegate: self)
    }
    
    private func addPickerTarget() {
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        viewModel.dateSelected = sender.date
    }
    
    @objc func keyboardWillAppear() {
        generateImpactWhenTouch()
        animateView(expand: true)
    }

    @objc func keyboardWillDisappear() {
        animateView(expand: false)
    }
    
    private func setupTextFieldsDelegate() {
        nameTextField.delegate = self
        lastNameTextField.delegate = self
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
        saveButton.roundCorner(shadow: true)
        navigationItem.leftBarButtonItem = setupBackButton(target: #selector(logOut))
        ServiceLoginManager(delegate: self).fetchUserLoggedImage { image in
            self.userImage.image = image
            self.userImage.roundCorner(shadow: true)
        }
        userNameLabel.text = userLogged?.name
    }
    
    @IBAction private func saveButtonTapped(_ sender: UIButton) {
        startLoading()
        generateImpactWhenTouch()
        validateName()
        validateLastName()
        setYears()
        validateBirthday()
        
        checkValidationErrors()
    }
    
    private func startLoading() {
        DispatchQueue.main.async {
            self.loader.startAnimating()
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            self.saveButton.isEnabled = false
        }
    }
    
    private func stopLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.loader.stopAnimating()
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.saveButton.isEnabled = true
        }
    }
    
    func validateName() {
        if let nameText = nameTextField.text {
            if !viewModel.isValidData(dataString: nameText, type: .name) {
                nameTextField.textColor = viewModel.errorColor
            } else {
                nameTextField.textColor = viewModel.defaultColor
            }
        }
    }
    
    func validateLastName() {
        if let lastNameText = lastNameTextField.text {
            if !viewModel.isValidData(dataString: lastNameText, type: .lastName) {
                lastNameTextField.textColor = viewModel.errorColor
            } else {
                lastNameTextField.textColor = viewModel.defaultColor
            }
        }
    }
    
    func setYears() {
        if let years = yearsTextField.text {
            viewModel.client.years = Int(years)
        }
    }
    
    func validateBirthday() {
        if !viewModel.isValidData(date: viewModel.dateSelected, type: .birthday) {
            datePicker.tintColor = viewModel.errorColor
        } else {
            viewModel.client.birthDate = viewModel.dateSelected.toString()
            datePicker.tintColor = viewModel.defaultColor
        }
    }
    
    func checkValidationErrors() {
        if !viewModel.errors.isEmpty {
            viewModel.presentDataErrorsMessage(delegate: self)
            stopLoading()
        } else {
            viewModel.saveUser(delegate: self, id: userLogged?.id)
                self.clearData()
                self.stopLoading()
        }
    }
    
    private func clearData() {
        nameTextField.text = ""
        lastNameTextField.text = ""
        yearsTextField.text = ""
    }
    
}

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")

        return (string == filtered)
    }
}
