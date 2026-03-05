//
//  getfile.swift
//  sls
//
//  Created by simesaba on 2026/03/04.
//
import Foundation

struct FileGeter {
    var files: [String] = []
    mutating func getFile(path: String, all: Bool = false) -> [String] {
        do {
            let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        //    let currentDirectory = FileManager.default.currentDirectoryPath
            let targetDirectory: URL = URL(fileURLWithPath: path, relativeTo: currentDirectory)
            let contents = try FileManager.default.contentsOfDirectory(at: targetDirectory, includingPropertiesForKeys: nil)
            for url in contents {
                let fileName = url.lastPathComponent
                if !all {
                    if fileName.hasPrefix(".") {
                        continue
                    }
                }
                files.append(fileName)
            }
        } catch {
            print("Failed to list directory contents: \(error)")
        }
        return files
    }
}
