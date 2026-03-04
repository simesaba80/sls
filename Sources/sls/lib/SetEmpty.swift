//
//  SetEmpty.swift
//  sls
//
//  Created by simesaba on 2026/03/04.
//
import Darwin
import TermKit

struct SetEmpty{
    var emptyFullScreen: [String] = []
    
    
    func getWindowSize() -> (row: Int, col: Int) {
        var w = winsize()
        guard ioctl(STDOUT_FILENO, TIOCGWINSZ, &w) == 0 else {
            // デフォルト値を返す（ioctlが失敗した場合）
            return (24, 80)
        }
        return (Int(w.ws_row), Int(w.ws_col))
    }
    
    mutating func makeEmptyString() -> [String] {
        let (row, col) = getWindowSize()
        // rowが0以下の場合はスキップ（クラッシュを防ぐ）
        guard row > 0, col > 0 else {
            return emptyFullScreen
        }
        for _ in 1...row {
            emptyFullScreen.append(String(repeating: " ", count: col))
        }
        return emptyFullScreen
    }
}
