//
//  UserModel.swift
//  FirebaseLogin
//
//  Created by Agustin Errecalde on 03/06/2021.
//

import Foundation

struct Users {
    var users: [User]?
}

extension Users: Decodable {
    enum Keys: String, CodingKey {
        case users
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        self.users = try container.decodeIfPresent([User].self, forKey: .users)
    }
}

struct User {
    var id: Int?
    var name: String?
    var lastName: String?
    var image: String?
    var years: Int?
    var birthDate: String?
}

extension User: Decodable {
    enum Keys: String, CodingKey {
        case id
        case name
        case lastName
        case image
        case years
        case birthDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.years = try container.decodeIfPresent(Int.self, forKey: .years)
        self.birthDate = try container.decodeIfPresent(String.self, forKey: .birthDate)
    }
    
    func toDictionary() -> [AnyHashable : Any] {
        var dic = [AnyHashable : Any]()
        if let name = name {
            dic["name"] = name
        }
        if let lastName = lastName {
            dic["lastName"] = lastName
        }
        if let years = years {
            dic["years"] = years
        }
        if let birthDay = birthDate {
            dic["birthDay"] = birthDay
        }
        
        return dic
    }
}
