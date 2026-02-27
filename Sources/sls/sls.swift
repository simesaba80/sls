// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser

@main
struct sls: ParsableCommand {
    @Argument(help: "名前を入力")
    var name: String
    
    mutating func run() throws {
        print("Hello, \(name)!")
    }
}
