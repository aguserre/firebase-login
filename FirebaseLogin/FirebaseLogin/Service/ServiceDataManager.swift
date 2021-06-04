//
//  ServiceDataManager.swift
//  FirebaseLogin
//
//  Created by Agustin Errecalde on 04/06/2021.
//

import FirebaseAuth
import FirebaseDatabase


typealias ServiceManagerFinishedSavedClient = ((Error?, DatabaseReference) -> Void)


class ServiceDataManager: NSObject {
    var dataBaseRef: DatabaseReference!
    
    private func checkDatabaseReference() {
        if dataBaseRef != nil {
            dataBaseRef.removeAllObservers()
        }
    }
    
    
    func saveClient(delegate: UIViewController, id: String, client: User, completion: @escaping ServiceManagerFinishedSavedClient) {
        checkDatabaseReference()
        dataBaseRef = Database.database().reference().child(id).child("clients").childByAutoId()
        var clientWithKey = client
        clientWithKey.id = dataBaseRef.key
        dataBaseRef.setValue(clientWithKey.toDictionary()) { error, ref in
            if let error = error {
                completion(error, ref)
                return
            }
            completion(nil, ref)
        }
    }
}
