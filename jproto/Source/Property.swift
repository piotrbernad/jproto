//
//  Property.swift
//  jproto
//
//  Created by Piotr Bernad on 05/10/2017.
//  Copyright © 2017 Appunite. All rights reserved.
//

import Foundation

struct Property {
    let name: String
    let type: ValueType
    
    var cammelCasedName: String {
        return name.split(separator: "_").reduce("", { (result, part) -> String in
            if part == "_" { return result }
            
            let partN: String = result.isEmpty ? String(part) : part.capitalized
            
            return result + partN
        })
    }
}
