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
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath, isDirectory: true)
        let target = URL(fileURLWithPath: path, relativeTo: currentDirectory)

        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: target.path, isDirectory: &isDirectory) else {
            print("No such file or directory: \(path)")
            return files
        }

        if isDirectory.boolValue {
            do {
                let contents = try FileManager.default.contentsOfDirectory(at: target, includingPropertiesForKeys: nil)
                for url in contents {
                    let fileName = url.lastPathComponent
                    if !all && fileName.hasPrefix(".") { continue }
                    files.append(fileName)
                }
            } catch {
                print("Failed to list directory contents: \(error)")
            }
        } else {
            files.append(target.lastPathComponent)
        }

        return files
    }
}
