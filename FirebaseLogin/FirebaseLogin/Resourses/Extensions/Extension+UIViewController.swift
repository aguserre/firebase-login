//
//  Extension+UIViewController.swift
//  FirebaseLogin
//
//  Created by Agustin Errecalde on 03/06/2021.
//

import UIKit


extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func createDefaultAlert(title: String, message:String, completion: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: acceptTitle, style: .default, handler: completion)
        alert.addAction(action)
        
        return alert
    }
    
    func presentAlertController(title: String, message:String, completion: ((UIAlertAction) -> Void)?) {
        let alert = createDefaultAlert(title: title, message: message, completion: completion)
        
        present(alert, animated: true, completion: nil)
    }
    
    func presentAlertControllerWithCancel(title: String, message:String, completion: ((UIAlertAction) -> Void)?) {
        let alert = createDefaultAlert(title: title, message: message, completion: completion)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func presentAlertControllerWithDoubleAction(title: String, message:String, completionSuccess: ((UIAlertAction) -> Void)?, completionFailed: ((UIAlertAction) -> Void)?) {
        let alert = createDefaultAlert(title: title, message: message, completion: completionSuccess)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: completionFailed)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func generateImpactWhenTouch() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func setupBackButton(target: Selector?) -> UIBarButtonItem {
        let newBackButton = UIBarButtonItem(barButtonSystemItem: .close,
                                            target: self,
                                            action:target)
        newBackButton.tintColor = .white
        return newBackButton
    }
    
}
