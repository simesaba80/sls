//
//  getfile.swift
//  sls
//
//  Created by simesaba on 2026/03/04.
//
import Foundation

struct FileGeter {
//    let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let currentDirectory = FileManager.default.currentDirectoryPath
    var files: [String] = []
    mutating func getFile(path: String, all: Bool = false) -> [String] {
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: currentDirectory)
            for url in contents {
                let fileName = URL(fileURLWithPath: url).lastPathComponent
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
