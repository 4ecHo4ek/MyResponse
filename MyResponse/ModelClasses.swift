//
//  ModelClasses.swift
//  MyResponse
//
//  Created by Сергей Цыганков on 27.05.2020.
//  Copyright © 2020 Сергей Цыганков. All rights reserved.
//

import RealmSwift

class Response: Object {
    @objc dynamic var name = ""
    @objc dynamic var describe: String?
    @objc dynamic var haveColor = true
    @objc dynamic var mark = 0
    @objc dynamic var imageData: Data?
    @objc dynamic var type: String?
    
    convenience init(name: String, describe: String?, haveColor: Bool, mark: Int,
                     imageData: Data?, type: String?) {
        self.init()
        self.name = name
        self.describe = describe
        self.haveColor = haveColor
        self.mark = mark
        self.imageData = imageData
        self.type = type
    }
}



class Colors: Object {
    @objc dynamic var red = 0.0
    @objc dynamic var green = 0.0
    @objc dynamic var blue = 0.0
    @objc dynamic var alpha = 0.0
    
    convenience init (red: Double, green: Double, blue: Double, alpha: Double) {
        self.init()
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}
