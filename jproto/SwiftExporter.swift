//
//  SwiftExporter.swift
//  jproto
//
//  Created by Piotr Bernad on 05/10/2017.
//  Copyright © 2017 Appunite. All rights reserved.
//

import Foundation

struct SwiftExporter: Exporter {
    
    private let separateFiles: Bool
    private let classPrefix: String
    private let fileExtension = ".swift"
    
    init(separateFiles: Bool, classPrefix: String) {
        self.separateFiles = separateFiles
        self.classPrefix = classPrefix
    }
    
    func exportModels(models: [ModelDescription]) throws {
        let files = try models.map { (model) -> ExporterOutput in
            return try processModel(model: model)
        }
    }
    
    private func processModel(model: ModelDescription) throws -> ExporterOutput {
        return ExporterOutput(model, "", fileExtension)
    }
}
