//
//  Exporter.swift
//  jproto
//
//  Created by Piotr Bernad on 05/10/2017.
//  Copyright © 2017 Appunite. All rights reserved.
//

import Foundation

struct ExporterOutput {
    let fileContent: String
    let fileExtension: String
    let model: ModelDescription
    
    init(_ model: ModelDescription, _ content: String, _ fileExtension: String) {
        self.fileContent = content
        self.model = model
        self.fileExtension = fileExtension
    }
}

protocol Exporter {
    init(separateFiles: Bool, classPrefix: String)
    
    func exportModels(models: [ModelDescription]) throws
}

extension Exporter {
    
    static func exporterForPlatform(_ platform: Platform, separateFiles: Bool, classPrefix: String) -> Exporter {
        switch platform {
        case .swift:
            return SwiftExporter(separateFiles: separateFiles, classPrefix: classPrefix)
        case .kotlin:
            return SwiftExporter(separateFiles: separateFiles, classPrefix: classPrefix)
        case .elixir:
            return SwiftExporter(separateFiles: separateFiles, classPrefix: classPrefix)
        }
    }
    
    func writeToFile(content: String, fileName: String) {
        
    }
}
