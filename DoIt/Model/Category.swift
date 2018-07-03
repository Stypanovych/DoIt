//
//  Category.swift
//  DoIt
//
//  Created by Coder on 7/3/18.
//  Copyright © 2018 Coder. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
