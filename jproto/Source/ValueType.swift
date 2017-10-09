//
//  ValueType.swift
//  jproto
//
//  Created by Piotr Bernad on 05/10/2017.
//  Copyright © 2017 Appunite. All rights reserved.
//

import Foundation

enum ValueError: Error {
    case unsupportedValueType
}

private let arrayTypeRegex = "(?<=Array<)(.*)(?=>)"

enum ValueType {
    case int(optional: Bool)
    case string(optional: Bool)
    case float(optional: Bool)
    case bool(optional: Bool)
    case array(optional: Bool, className: String)
    case relation(optional: Bool, className: String)
    
    func isOptional() -> Bool {
        switch self {
        case .int(let o):
            return o
        case .string(let p):
            return p
        case .array(let t, _):
            return t
        case .float(let i):
            return i
        case .relation(let n, _):
            return n
        case .bool(let a):
            return a
        }
    }
    
    init(_ rawValue: String) throws {
        let base = rawValue.replacingOccurrences(of: " ", with: "")
        let optional = base.contains("?")
        
        if base.contains("String") {
            self = .string(optional: optional)
        } else if base.contains("Int") {
            self = .int(optional: optional)
        } else if base.contains("Float") {
            self = .float(optional: optional)
        } else if base.contains("Bool") {
            self = .bool(optional: optional)
        } else if base.contains("Array") {
            guard let type = matches(for: arrayTypeRegex, in: rawValue).first else {
                throw ValueError.unsupportedValueType
            }
            
            var className = type.replacingOccurrences(of: "JSONProto.", with: "").replacingOccurrences(of: "?", with: "")
            
            self = .array(optional: optional, className: className)
        } else {
            let relationClass = base.replacingOccurrences(of: "JSONProto.", with: "").replacingOccurrences(of: "?", with: "")
            self = .relation(optional: optional, className: relationClass)
        }
        
    }
}
