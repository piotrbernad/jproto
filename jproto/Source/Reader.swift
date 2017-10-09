//
//  ProtoReader.swift
//  jproto
//
//  Created by Piotr Bernad on 05/10/2017.
//  Copyright © 2017 Appunite. All rights reserved.
//

import Foundation

enum ReaderError: Error {
    case couldNotReadProtoFiles
    case invalidProtoFile
}

typealias ProtoFile = String
typealias ClassName = String

private let protoFileExtension = "jproto"
private let extractClassNameRegex = "(?<=JSONProto.)(.*)(?= )"
private let extractPropertiesRegex = "(?<=var )(.*)(?=\n)"

struct ModelDescription {
    let properties: [Property]
    let name: ClassName
}

struct Reader {
    
    let directory: String
    
    let directoryUrl: URL
    
    let fileManager = FileManager.default
    
    init(directory: String) throws {
        self.directory = directory
        
        guard let url = URL(string: directory) else {
            throw ReaderError.couldNotReadProtoFiles
        }
        
        self.directoryUrl = url
    }
    
    func read() throws -> [ModelDescription] {
        
        let protoFileUrls: [URL] = try fileManager.contentsOfDirectory(at: self.directoryUrl, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles).filter({ (url) -> Bool in
            return url.pathExtension.contains("jproto")
        })
        
        let protoFiles = try protoFileUrls.map { (url) -> ProtoFile in
            return try String(contentsOf: url)
        }
        
        return try protoFiles.map { try analyzeProtoFile(file: $0) }
    }
    
    func analyzeProtoFile(file: ProtoFile) throws -> ModelDescription {
        let className = try file.className()
        let properties = try file.properties()
        
        return ModelDescription(properties: properties, name: className)
    }
}

fileprivate extension ProtoFile {
    func className() throws -> ClassName {
        guard let name = matches(for: extractClassNameRegex, in: self).first else {
            throw ReaderError.invalidProtoFile
        }
        
        return name
    }
    
    func properties() throws -> [Property] {
        let props = try matches(for: extractPropertiesRegex, in: self)
            .map({ (propertyLine) -> Property in
                let components = propertyLine.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).split(separator: ":")
                let name = String(components[0])
                let type = try ValueType(String(components[1]))
                
                return Property(name: name, type: type)
            })
        
        return props
        
    }
}


