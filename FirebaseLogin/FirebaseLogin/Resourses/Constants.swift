//
//  Constants.swift
//  FirebaseLogin
//
//  Created by Agustin Errecalde on 05/06/2021.
//

let appTitle = "My Clients APP"
let kMinAge = 13
let kMaxAge = 120
let kMinStringToAccept = 2
let proofClientTestableId = "1234567890"
let clientDbReference = "clients"
let newClient = User(name: "Dustin", lastName: "Henderson", years: 18, birthDate: "01/01/2003")
let dateFormat = "dd/MM/yyyy"
let appLogoImageName = "login-logo"
let fbLogoImageName = "logo-fb"
let charactersAcceptable = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
let fillCLientDataTitle = "Fill Client data"
let waitTitle = "Wait!"
let errorTitle = "Error"
let cancelTitle = "Cancel"
let acceptTitle = "OK"
let appFont = "HelveticaNeue-Medium"
let defaultErrorMessage = "An error ocurred. Try again later"
let facebookPermissions = "picture.width(480).height(480)"
let successTitle = "Success"
let clientSavedMessage = "Client saved"
let closeSessionWarninMessage = "Are you sure you want to close the session?"

enum DataError: String {
    case name = "Wrong name, must contain more than 3 characters"
    case lastName = "Wrong lastname, must contain more than 3 characters"
    case birthdayToYoung = "Must be over 13 years old"
    case birthdayToOld = "Are you a dinosaur HaHaHa?"
    case birthdayNotMatch = "Your age does not match the selected date"
}
