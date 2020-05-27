//
//  StorageManager.swift
//  MyResponse
//
//  Created by Сергей Цыганков on 27.05.2020.
//  Copyright © 2020 Сергей Цыганков. All rights reserved.
//

import RealmSwift

let realm = try! Realm()
let realmColor =  try! Realm()

class StorageManager {
    
    static func saveObject(myResponse object: Response) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    static func deleteObject(myResponse object: Response) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
    static func saveColor(withNumbers color: Colors) {
        try! realmColor.write {
            realmColor.add(color)
        }
    }
    
    static func deleteColor(withNumbers color: Colors) {
        try! realmColor.write {
            realmColor.delete(color)
        }
    }
}
