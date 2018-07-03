//
//  Item.swift
//  DoIt
//
//  Created by Coder on 7/3/18.
//  Copyright © 2018 Coder. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var isDone : Bool = false
    @objc dynamic var dataCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
