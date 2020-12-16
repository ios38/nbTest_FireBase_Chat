//
//  Message.swift
//  nbTest
//
//  Created by Maksim Romanov on 04.12.2020.
//

import Foundation
import Firebase

class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var date: Double?
    var toId: String?
    var imageUrl: String?
    var imageWidht: Float?
    var imageHeight: Float?

    init(dictionary: [String: AnyObject]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.date = dictionary["date"] as? Double
        self.toId = dictionary["toId"] as? String
        self.imageUrl = dictionary["imageUrl"] as? String
        self.imageWidht = dictionary["imageWidht"] as? Float
        self.imageHeight = dictionary["imageHeight"] as? Float
    }

    func chatPartnerId() -> String? { //FiXME: to var?
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
