// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import ArgumentParser

@main
struct sls: ParsableCommand {
    @Flag(name: .shortAndLong, help: "全て表示")
    var all: Bool = false
    
    @Option(name: .shortAndLong, help: "虚無オプション")
    var name: Int?
    @Argument(help: "パスを入力")
    var path: String = "."
    mutating func run() throws {
        var fileGeter = FileGeter()
        let files = fileGeter.getFile(path: path, all: all)
        let normalizingFile = NormalizingFiles()
        let normalizedFiles = normalizingFile.normalizingFiles(files: files)
        let setEmpty = SetEmpty()
//        let emptyFullScreens = setEmpty.makeEmptyString()
//        for emptyFullScreen in emptyFullScreens {
//            print(emptyFullScreen)
//        }
        let sl = SL()
        let windowSize = setEmpty.getWindowSize()
        sl.run(row: windowSize.row, col: windowSize.col, normalizedFiles: normalizedFiles)
    }
}
