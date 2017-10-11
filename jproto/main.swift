//
//  main.swift
//  jproto
//
//  Created by Piotr Bernad on 05/10/2017.
//  Copyright © 2017 Appunite. All rights reserved.
//

import Foundation

let cli = CommandLine()

let platformOption = EnumOption<Platform>(longFlag: "platform", required: true,
                               helpMessage: "Platform [swift | kotlin | elixir]")

let filesPathOption = StringOption(shortFlag: "d", longFlag: "dir", required: true,
                            helpMessage: "Dir to search proto files")

let exportPathOption = StringOption(shortFlag: "o", longFlag: "output", required: false,
                                   helpMessage: "Output path to export files")

let classPrefixOption = StringOption(longFlag: "prefix", required: false,
                             helpMessage: "Prefix for classes (Module name in case of elixir)")

let packageOption = StringOption(longFlag: "package", required: false,
                                     helpMessage: "Package for Kotlin export")

let separateFilesOption = BoolOption(shortFlag: "s", required: false, helpMessage: "Add -s flag to generate every model in to separate file")

cli.setOptions([platformOption, filesPathOption, classPrefixOption, separateFilesOption, exportPathOption, packageOption])

do {
    
    try cli.parse()
    
    let path = filesPathOption.value!
    let classPrefix = classPrefixOption.value ?? ""
    let separateFiles = separateFilesOption.value
    let platform = platformOption.value!
    let exportPath = exportPathOption.value ?? path
    let package = packageOption.value ?? ""
    
    let reader = try Reader(directory: path)

    let models = try reader.read()
    
    guard let exportUrl = URL(string: exportPath) else {
        throw JProtoError.invalidExportUrl
    }
    
    let exporter = exporterForPlatform(platform, separateFiles: separateFiles, classPrefix: classPrefix, exportBaseURL: exportUrl, package: package)
    
    try exporter.exportModels(models: models)
    
    print("==")
    
} catch (let error) {
    cli.printUsage(error)
    exit(EX_USAGE)
}


