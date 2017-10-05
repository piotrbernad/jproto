//
//  main.swift
//  jproto
//
//  Created by Piotr Bernad on 05/10/2017.
//  Copyright © 2017 Appunite. All rights reserved.
//

import Foundation

let path = "/Users/piotrbernad/appunite/jproto/"

do {
    let reader = try Reader(directory: path)

    let models = try reader.read()
    
    print(models)
    
} catch (let error) {
    print(error)
}


