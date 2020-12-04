//
//  Message.swift
//  nbTest
//
//  Created by Maksim Romanov on 04.12.2020.
//

import Foundation

class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var date: Double?
    var toId: String?

    init(dictionary: [String: AnyObject]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.date = dictionary["date"] as? Double
        self.toId = dictionary["toId"] as? String
    }
}
