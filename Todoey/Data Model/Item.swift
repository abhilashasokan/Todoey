//
//  Item.swift
//  Todoey
//
//  Created by Abhilash on 28/11/18.
//  Copyright © 2018 SweetGodzillas. All rights reserved.
//

import Foundation

class Item: Codable {
    var taskName: String = ""
    var taskStatus: Bool = false
    
    init() {
        self.taskName = ""
        self.taskStatus = false
    }
}
