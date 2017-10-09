//
//  ElixirExporter.swift
//  jproto
//
//  Created by Piotr Bernad on 06/10/2017.
//  Copyright © 2017 Appunite. All rights reserved.
//

import Foundation

struct ElixirExporter: Exporter {
    let separateFiles: Bool
    private let classPrefix: String
    let exportBaseURL: URL
    
    let fileExtension = ".ex"
    
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
        let header = "defmodule \(classPrefix)\(model.name) do\n"
        
        let enforce = "  @enforce_keys [" + model.properties.filter{ !$0.type.isOptional() }.map { (prop) -> String in
            return ":\(prop.name)"
            }.joined(separator: ", ") + "]\n"
        
        let properties = "  defscruct [" + model.properties
            .sorted(by: { (lhs, rhs) -> Bool in
                if case .array = lhs.type { return false }
                
                return true
            })
            .map { (prop) -> String in
                if case .array = prop.type {
                    return "\(prop.name): []"
                }
                return ":\(prop.name)"
            }.joined(separator: ", ") + "]"
        
        
        let structure = header + enforce + properties + "\nend"
        
        return structure
    }
}
