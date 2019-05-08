//
//  RealmExtension.swift
//  Receigo
//
//  Created by Mac on 12/25/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    
    static func execute(_ completion: (Realm) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            completion(realm)
        }
    }
    
    static func deleteAll(objectType: Any) {
        let realm = try! Realm()
        realm.delete(realm.objects(objectType as! Object.Type))
    }
}
