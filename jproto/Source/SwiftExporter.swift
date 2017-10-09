//
//  SwiftExporter.swift
//  jproto
//
//  Created by Piotr Bernad on 05/10/2017.
//  Copyright © 2017 Appunite. All rights reserved.
//

import Foundation

struct SwiftExporter: Exporter {
    
    let separateFiles: Bool
    private let classPrefix: String
    let exportBaseURL: URL
    let fileExtension = ".swift"

    
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
        let header = ["// Generated by jproto",
                      "import Foundation",
                      "struct \(model.name): Codable {\n"].joined(separator: "\n\n")
            
        let properties = model.properties.map { (prop) -> String in
            return "\tlet \(prop.cammelCasedName): \(valueDescription(prop.type)) "
        }.joined(separator: "\n")
        
        let codingKeysHeader = "\n\n\tenum CodingKeys: String, CodingKey {\n"
        
        let codingKeys = model.properties.map { (prop) -> String in
            return "\t\tcase \(prop.cammelCasedName) = \"\(prop.name)\""
        }.joined(separator: "\n")
        
        let structure = header + properties + codingKeysHeader + codingKeys + "\n\t}" + "\n}"

        return structure
    }
    
    private func valueDescription(_ val: ValueType) -> String {
        switch val {
        case .array(let optional, let className):
            return optional ? "[\(className)]?" : "[\(className)]"
        case .bool(let optional):
            return optional ? "Bool?" : "Bool"
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
