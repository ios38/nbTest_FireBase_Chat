//
//  FireAd.swift
//  nbTest
//
//  Created by Maksim Romanov on 01.12.2020.
//

import Foundation
import Firebase
import FirebaseFirestore

struct FirebaseAd {
    let title: String
    let date: Date
    
    let ref: DatabaseReference?
    
    private let dateFormatter = DateFormatter()

    init(title: String, date: Date) {
        self.title = title
        self.date = date
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" //"2020-11-24 10:19:17 +0000"

        guard let value = snapshot.value as? [String : Any],
              let title = value["title"] as? String,
              let stringDate = value["date"] as? String,
              let date = dateFormatter.date(from: stringDate)
        else { return nil }
        
        self.title = title
        self.date = date
        self.ref = snapshot.ref
    }
    
    func toAnyObject() -> [String : Any] {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" //"2020-11-24 10:19:17 +0000"
        return [
            "title": title,
            "date": dateFormatter.string(from: Date())
        ]
    }
}

struct FirestoreAd {
    let title: String
    let date: Date
    
    //let ref: DatabaseReference?
    
    private let dateFormatter = DateFormatter()

    init(title: String, date: Date) {
        self.title = title
        self.date = date
        //self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" //"2020-11-24 10:19:17 +0000"

        guard let value = snapshot.value as? [String : Any],
              let title = value["title"] as? String,
              let stringDate = value["date"] as? String,
              let date = dateFormatter.date(from: stringDate)
        else { return nil }
        
        self.title = title
        self.date = date
        //self.ref = snapshot.ref
    }
    
    func toAnyObject() -> [String : Any] {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" //"2020-11-24 10:19:17 +0000"
        return [
            "title": title,
            "date": dateFormatter.string(from: Date())
        ]
    }
}
