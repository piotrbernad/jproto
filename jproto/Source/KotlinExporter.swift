//
//  KotlinExporter.swift
//  jproto
//
//  Created by Piotr Bernad on 06/10/2017.
//  Copyright © 2017 Appunite. All rights reserved.
//

import Foundation

struct KotlinExporter: Exporter {
    let separateFiles: Bool
    private let classPrefix: String
    let exportBaseURL: URL
    
    let fileExtension = ".kt"
    
    init(separateFiles: Bool, classPrefix: String, exportBaseURL: URL) {
        self.separateFiles = separateFiles
        self.classPrefix = classPrefix
        self.exportBaseURL = exportBaseURL
    }
    
    func processModel(_ model: ModelDescription) throws -> ExporterOutput {
        let content = generateContent(model)
        return ExporterOutput(model, content, fileExtension)
    }
    
    private func generateContent(_ model: ModelDescription) -> String {
        let header = ["data class \(model.name)("].joined(separator: "\n\n")
        
        let properties = model.properties.map { (prop) -> String in
            return "val \(prop.cammelCasedName): \(valueDescription(prop.type))"
            }.joined(separator: ", ")
        
      
        let structure = header + properties + ")"
        
        return structure
    }
    
    private func valueDescription(_ val: ValueType) -> String {
        switch val {
        case .array(let optional, let className):
            return optional ? "List<\(className)>?" : "List<\(className)>"
        case .bool(let optional):
            return optional ? "Boolean?" : "Boolean"
        case .int(let optional):
            return optional ? "Int?" : "Int"
        case .float(let optional):
            return optional ? "Float?" : "Float"
        case .relation(let optional, let className):
            return optional ? (className + "?") : className
        case .string(let optional):
            return optional ? "String?" : "String"
        }
    }
}
