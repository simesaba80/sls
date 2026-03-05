//
//  NormlizingFiles.swift
//  sls
//
//  Created by simesaba on 2026/03/05.
//

struct NormlizingFiles{
    func normlizingFiles(files: [String]){
        var length = 0
        for file in files {
            if length > file.count {
                length = file.count
            }
        }
        print("max length: ", length)
    }
}
