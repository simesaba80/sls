//
//  NormlizingFiles.swift
//  sls
//
//  Created by simesaba on 2026/03/05.
//

struct NormalizingFiles{
    func normalizingFiles(files: [String]) -> [String]{
        let length = files.map({$0.count}).max() ?? 0
        let normalizedFiles: [String] = files.map{$0.padding(toLength: length, withPad: " ", startingAt: 0)}
        print(normalizedFiles)
        return normalizedFiles
    }
}
