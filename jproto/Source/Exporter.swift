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
    var exportBaseURL: URL { get }
    
    var fileExtension: String { get }
    
    var separateFiles: Bool { get }
    
    init(separateFiles: Bool, classPrefix: String, exportBaseURL: URL)
    
    func exportModels(models: [ModelDescription]) throws
    
    func processModel(_ model: ModelDescription) throws -> ExporterOutput
}

extension Exporter {
    func exportModels(models: [ModelDescription]) throws {
        let files = try models.map { (model) -> ExporterOutput in
            return try processModel(model)
        }
        
        if !separateFiles {
            
            let content = files.map { $0.fileContent }.joined(separator: "\n\n")
            let fileName = "APIModels" + fileExtension
            
            try write(content: content, toURL: urlFor(fileName: fileName))
            
            return
        }
        
        let content = try files.map { ($0.fileContent, ($0.model.name + fileExtension)) }.map { (content, file) -> Void in
            let url = urlFor(fileName: file)
            try write(content: content, toURL: url)
        }
        
        
    }
    func write(content: String, toURL: URL) throws {
        let data = content.data(using: .utf8)
        
        print(content)
        print("\n\n")
        
        try data?.write(to: toURL)
    }
    
    func urlFor(fileName: String) -> URL {
        let url = URL(fileURLWithPath: self.exportBaseURL.appendingPathComponent(fileName).absoluteString)
        return url
    }
}

func exporterForPlatform(_ platform: Platform, separateFiles: Bool, classPrefix: String, exportBaseURL: URL, package: String = "") -> Exporter {
    switch platform {
    case .swift:
        return SwiftExporter(separateFiles: separateFiles, classPrefix: classPrefix, exportBaseURL: exportBaseURL)
    case .kotlin:
        var ke = KotlinExporter(separateFiles: separateFiles, classPrefix: classPrefix, exportBaseURL: exportBaseURL)
        ke.package = package
        return ke
    case .elixir:
        return ElixirExporter(separateFiles: separateFiles, classPrefix: classPrefix, exportBaseURL: exportBaseURL)
    }
}

