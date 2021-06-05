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
    
    
    func saveClient(isTestable: Bool = false, delegate: UIViewController, id: String, client: User, completion: @escaping ServiceManagerFinishedSavedClient) {
        checkDatabaseReference()
        if isTestable {
            dataBaseRef = Database.database().reference().child(id).child(clientDbReference).child(proofClientTestableId)
        } else {
            dataBaseRef = Database.database().reference().child(id).child(clientDbReference).childByAutoId()
        }
        
        var clientWithKey = client
        clientWithKey.id = isTestable ? proofClientTestableId : dataBaseRef.key
        dataBaseRef.setValue(clientWithKey.toDictionary()) { error, ref in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error, ref)
                    return
                }
                completion(nil, ref)
            }
        }
    }
    
    //Create method to check if client is saved into DB
    func checkIfClientExistInDB(id: String, completion: @escaping (Bool) -> Void) {
        var dataBaseRef: DatabaseReference!
        dataBaseRef = Database.database().reference().child(id).child(clientDbReference)
        dataBaseRef.observeSingleEvent(of: .value) { snapshot in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                completion(snapshots.count > 0)
            } else {
                completion(false)
            }
        }
    }
}
