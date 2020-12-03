//
//  User.swift
//  nbTest
//
//  Created by Maksim Romanov on 02.12.2020.
//

import Foundation

class User: NSObject {
    //var id: String?
    //var name: String?
    var email: String?
    var profileImageUrl: String?
    
    init(dictionary: [String: AnyObject]) {
        //self.id = dictionary["id"] as? String
        //self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}

