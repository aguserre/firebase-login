//
//  MainViewControllerViewModel.swift
//  FirebaseLogin
//
//  Created by Agustin Errecalde on 03/06/2021.
//

import UIKit

enum RequiredClientData {
    case name, lastName, years, birthday
}
enum DataError: String {
    case name = "NOMBRE INCORRECTO"
    case lastName = "APELLIDO INCORRECTO"
    case birthdayToYoung = "Debe ser Mayor de 18 anios"
    case birthdayToOld = "Usted es un dinosaurio?"
    case birthdayNotMatch = "No coincide su edad con la fecha seleccionada"
}

class MainViewControllerViewModel {
        
    var kMinYears = 13
    
    var errors = [DataError]()
    
    var dateSelected = Date()
            
    var topConstraintCompress: CGFloat {
        return 30
    }
    var topConstraintExpanded: CGFloat {
        return 160
    }
    
    var nameConstraintCompress: CGFloat {
        return 20
    }
    var nameConstraintExpanded: CGFloat {
        return 120
    }
    var newClientText: String {
        return "Fill Client data"
    }
    
    var errorColor: UIColor {
        return .red
    }
    
    var defaultColor: UIColor {
        return .label
    }
    
    var client = User()
    
    func addKeyboardObservers(_ delegate: MainViewController) {
        NotificationCenter.default.addObserver(delegate, selector: #selector(delegate.keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(delegate, selector: #selector(delegate.keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func removeKeyboardObservers(_ delegate: MainViewController) {
        NotificationCenter.default.removeObserver(delegate)
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
        
    func isValidData(dataString: String = "", dataInt: Int = 0, date: Date = Date(), type: RequiredClientData) -> Bool {
        switch type {
        case .name:
            return validateFullName(name: dataString, type: .name)
        case .lastName:
            return validateFullName(name: dataString, type: .lastName)
        default:
            return validateBirthDayDate(date: date)
        }
    }
    
    private func validateFullName(name: String, type: RequiredClientData) -> Bool {
        let val = name.count > 2
        if !val {
            errors.append(type == .name ? .name : .lastName)
        } else {
            if type == .name {
                client.name = name
            } else {
                client.lastName = name
            }
        }
        return val
    }
    
    private func validateBirthDayDate(date: Date) -> Bool {
        client.birthDate = date.toString()
        let years = compareDates(birthDay: date)
        let matchedWithYears = years == client.years
        if !matchedWithYears {
            errors.append(.birthdayNotMatch)
            return false
        }
        
        let hasRequiredYears = years >= kMinYears
        let isToOld = years > 120
        if !hasRequiredYears {
            errors.append(.birthdayToYoung)
        }
        if isToOld {
            errors.append(.birthdayToOld)
        }
        
        return hasRequiredYears && !isToOld && matchedWithYears
    }
    
    func compareDates(birthDay: Date) -> Int {
        let now = Date()
        let birthday: Date = birthDay
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        
        return age
    }
    
    func presentDataErrorsMessage(delegate: UIViewController) {
        var separatedErrors = ""
        for error in errors {
            separatedErrors = separatedErrors+error.rawValue.capitalized+"\n"
        }
        delegate.presentAlertController(title: "Error", message: separatedErrors, completion: nil)
        errors.removeAll()
    }
    
    func saveUser(delegate: UIViewController, id: String?) {
        if let uid = id {
            ServiceDataManager().saveClient(delegate: delegate, id: uid, client: client) { error, ref in
                if let error = error {
                    delegate.presentAlertController(title: "Error", message: error.localizedDescription, completion: nil)
                return
                }
                
                delegate.presentAlertController(title: "Success!", message: "Client saved", completion: nil)
            }
        }
        
    }
    
}
