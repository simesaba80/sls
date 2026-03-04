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
    var path: String
    mutating func run() throws {
        print("Hello \(path)")
        var fileGeter = FileGeter()
        let files = fileGeter.getFile(path: path, all: all)
        for file in files {
            print(file, terminator: " ")
        }
        print()
        var setEmpty = SetEmpty()
//        let emptyFullScreens = setEmpty.makeEmptyString()
//        for emptyFullScreen in emptyFullScreens {
//            print(emptyFullScreen)
//        }
        var SL = SL()
        let windowSize = setEmpty.getWindowSize()
        SL.run(row: windowSize.row, col: windowSize.col)
    }
}
