//
//  FirebaseLoginTests.swift
//  FirebaseLoginTests
//
//  Created by Agustin Errecalde on 03/06/2021.
//

import XCTest
import FirebaseDatabase
import FirebaseAuth
@testable import FirebaseLogin

class FirebaseLoginTests: XCTestCase {

    let mainVC = MainViewController()
    //User created for proofs
    let clientProofId = "1234567890"
    let newClient = User(name: "Dustin", lastName: "Henderson", years: 18, birthDate: "01/01/2003")
    
    //MARK:- New client data validations
    func test_invalidName() {
        let nameStringEmpty = ""
        let nameStringWithSpace = " "
        let nameStringOneCharacter = "a"
        let nameStringThoCharacters = "aa"
        //Name
        XCTAssertFalse(mainVC.viewModel.isValidData(dataString: nameStringEmpty ,type: .name))
        XCTAssertFalse(mainVC.viewModel.isValidData(dataString: nameStringWithSpace ,type: .name))
        XCTAssertFalse(mainVC.viewModel.isValidData(dataString: nameStringOneCharacter ,type: .name))
        XCTAssertFalse(mainVC.viewModel.isValidData(dataString: nameStringThoCharacters ,type: .name))
        //Lastname
        XCTAssertFalse(mainVC.viewModel.isValidData(dataString: nameStringEmpty ,type: .lastName))
        XCTAssertFalse(mainVC.viewModel.isValidData(dataString: nameStringWithSpace ,type: .lastName))
        XCTAssertFalse(mainVC.viewModel.isValidData(dataString: nameStringOneCharacter ,type: .lastName))
        XCTAssertFalse(mainVC.viewModel.isValidData(dataString: nameStringThoCharacters ,type: .lastName))
    }
    
    func test_validName() {
        let nameString = "abc"
        let nameStringWithSpaces = "abcd adksj"
        let nameStringWithUppercase = "AbcD AdkSj"
        //Keyboard limited characters if not letters
        
        //Name
        XCTAssertTrue(mainVC.viewModel.isValidData(dataString: nameStringWithSpaces ,type: .name))
        XCTAssertTrue(mainVC.viewModel.isValidData(dataString: nameString ,type: .name))
        XCTAssertTrue(mainVC.viewModel.isValidData(dataString: nameStringWithUppercase ,type: .name))
        //Lastname
        XCTAssertTrue(mainVC.viewModel.isValidData(dataString: nameStringWithSpaces ,type: .lastName))
        XCTAssertTrue(mainVC.viewModel.isValidData(dataString: nameString ,type: .lastName))
        XCTAssertTrue(mainVC.viewModel.isValidData(dataString: nameStringWithUppercase ,type: .lastName))
    }
    
    func test_successSaveYearsString() {
        let year = "18"
        mainVC.viewModel.client.years = Int(year)
        
        XCTAssertEqual(mainVC.viewModel.client.years, 18)
        XCTAssertFalse(mainVC.viewModel.client.years != 18)
    }
    
    func test_clientToYoung() {
        mainVC.viewModel.client.years = 12
        let birthday = generateDate(string: "31/01/2007")
        
        XCTAssertFalse(mainVC.viewModel.isValidData(date: birthday, type: .birthday))
    }
    
    func test_minYearsForClient() {
        mainVC.viewModel.client.years = 13
        let birthday = generateDate(string: "31/01/2008")
        
        XCTAssertTrue(mainVC.viewModel.isValidData(date: birthday, type: .birthday))
    }
    
    func test_clientToOld() {
        mainVC.viewModel.client.years = 121
        let birthday = generateDate(string: "31/01/1900")
        
        XCTAssertFalse(mainVC.viewModel.isValidData(date: birthday, type: .birthday))
    }
    
    func test_maxYearsForClient() {
        mainVC.viewModel.client.years = 120
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let birthdate = formatter.date(from: "31/01/1901")!
        
        XCTAssertTrue(mainVC.viewModel.isValidData(date: birthdate, type: .birthday))
    }
    
    func test_clientGreaterThenBirthday() {
        mainVC.viewModel.client.years = 32
        let birthday = generateDate(string: "21/12/1989")
        
        XCTAssertFalse(mainVC.viewModel.isValidData(date: birthday, type: .birthday))
    }
    
    func test_clientEqualThenBirthday() {
        mainVC.viewModel.client.years = 31
        let birthday = generateDate(string: "21/12/1989")
        
        XCTAssertTrue(mainVC.viewModel.isValidData(date: birthday, type: .birthday))
    }
    
    func test_clientLessThenBirthday() {
        mainVC.viewModel.client.years = 30
        let birthday = generateDate(string: "21/12/1989")
        
        XCTAssertFalse(mainVC.viewModel.isValidData(date: birthday, type: .birthday))
    }
    
    //MARK:- Check if proof user exist into DB
    func test_checkIfTestUserExistInDB() throws {
        let service = ServiceDataManager()
        let expectation = self.expectation(description: "Waiting for firebase call complete.")
        enum UserStatusInDB: Int {
            case notExist = 0
            case exist = 1
            case error = 2
        }
        
        var result: UserStatusInDB = .notExist
        
        service.checkIfClientExistInDB(id: clientProofId) { exist in
            result = exist ? .exist : .notExist
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            switch result {
            case .exist:
                debugPrint("Client exist into DB")
                XCTAssertEqual(result.rawValue, 1)
            case .notExist:
                debugPrint("Client not exist into DB")
                XCTAssertEqual(result.rawValue, 0)
            default :
                XCTFail()
            }
        }
    }
    
    //MARK:- Save proof client into DB
    func test_addClientSuccess() throws {
        let service = ServiceDataManager()
        let expectation = self.expectation(description: "Waiting for firebase call complete.")
        var result: Result<Bool, Error>?
        
        service.saveClient(isTestable: true, delegate: mainVC, id: clientProofId, client: newClient) { (error, res) in
            if let error = error {
                result = .failure(error)
            } else {
                result = .success(true)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            switch result {
            case .success(let success):
                XCTAssertEqual(success, true)
            case .failure,
                 .none:
                XCTFail()
            }
        }
    }
    
    private func generateDate(string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        guard let birthdate = formatter.date(from: string) else {
            return Date()
        }
        
        return birthdate
    }

}
