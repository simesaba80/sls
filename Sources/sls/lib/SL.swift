//
//  SL.swift
//  sls
//
//  Created by simesaba on 2026/03/04.
//

import Foundation
import TermKit


/// SLのアスキーアート データ構造
/// AA copy from https://github.com/mtoyoda/sl/blob/master/sl.h
struct SL {
    /// 煙のアニメーションフレーム
    static let smoke: [[String]] = [
        [
            "                      (@@) (  ) (@)  ( )  @@    ()    @     O     @     O      @",
            "                 (   )",
            "             (@@@@)",
            "          (    )",
            "",
            "        (@@@)",
        ],
        [
            "                      (  ) (@@) ( )  (@)  ()    @@    O     @     O     @      O",
                "                 (@@@)",
            "             (    )",
            "          (@@@@)",
            "",
            "        (   )",
        ],
    ]
    
    /// SLの上部
    static let slTop: [String] = [
        "      ====        ________                ___________ ",
        "  _D _|  |_______/        \\__I_I_____===__|_________| ",
        "   |(_)---  |   H\\________/ |   |        =|___ ___|   ",
        "   /     |  |   H  |  |     |   |         ||_| |_||   ",
        "  |      |  |   H  |__--------------------| [___] |   ",
        "  | ________|___H__/__|_____/[][]~\\_______|       |   ",
        "  |/ |   |-----------I_____I [][] []  D   |=======|__ ",
    ]
    
    /// 車輪のアニメーションフレーム
    static let wheel: [[String]] = [
        [
            "__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ",
            " |/-=|___|=    ||    ||    ||    |_____/~\\___/        ",
            "  \\_/      \\_O=====O=====O=====O/      \\_/            ",
        ],
        [
            "__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ",
            " |/-=|___|=   O=====O=====O=====O|_____/~\\___/        ",
            "  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/            ",
        ],
        [
            "__/ =| o |=-~O=====O=====O=====O\\ ____Y___________|__ ",
            " |/-=|___|=    ||    ||    ||    |_____/~\\___/        ",
            "  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/            ",
        ],
        [
            "__/ =| o |=-O=====O=====O=====O \\ ____Y___________|__ ",
            " |/-=|___|=    ||    ||    ||    |_____/~\\___/        ",
            "  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/            ",
        ],
        [
            "__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ",
            " |/-=|___|=O=====O=====O=====O   |_____/~\\___/        ",
            "  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/            ",
        ],
        [
            "__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ",
            " |/-=|___|=    ||    ||    ||    |_____/~\\___/        ",
            "  \\_/      \\O=====O=====O=====O_/      \\_/            ",
        ],
    ]
    
    /// SLのスペース
    static let slSpace: [String] = [
        "                                                      "
    ]
    
    /// 石炭車両
    static let coalWagon: [String] = [
        "                              ",
        "                              ",
        "    _________________         ",
        "   _|                \\_____A  ",
        " =|                        |  ",
        " -|                        |  ",
        "__|________________________|_ ",
        "|__________________________|_ ",
        "   |_D__D__D_|  |_D__D__D_|   ",
        "    \\_/   \\_/    \\_/   \\_/    ",
    ]
    
    /// 石炭車両のスペース
    static let coalSpace: [String] = [
        "                              "
    ]
    /// 貨物車両の構造
    struct Cargo {
        let top: String
        let floor: String
        let leftAndRightWall: String
        let wheel: [String]
        let minContentWidth: Int
        let maxContentHeight: Int
        let wagon: [String]
        
        static let `default` = Cargo(
            top: "_",
            floor: "_",
            leftAndRightWall: "|",
            wheel: [
                "|_D__D__D_|",
                " \\_/   \\_/",
            ],
            minContentWidth: 26,
            maxContentHeight: 5,
            wagon: [
                "                            ",
                "____________________________",
                "|                          |",
                "|                          |",
                "|                          |",
                "|                          |",
                "|                          |",
                "|__________________________|",
                "  |_D__D__D_|  |_D__D__D_|  ",
                "   \\_/   \\_/    \\_/   \\_/   ",
            ]
        )
    }
    private let trainLines: [String] = [
            "      ====        ________                ___________ ",
            "  _D _|  |_______/        \\__I_I_____===__|_________| ",
            "   |(_)---  |   H\\________/ |   |        =|___ ___|   ",
            "   /     |  |   H  |  |     |   |         ||_| |_||   ",
            "  |      |  |   H  |__--------------------| [___] |   ",
            "  | ________|___H__/__|_____/[][]~\\_______|       |   ",
            "  |/ |   |-----------I_____I [][] []  D   |=======|__ ",
            "__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ",
            " |/-=|___|=    ||    ||    ||    |_____/~\\___/        ",
            "  \\_/      \\_O=====O=====O=====O/      \\_/            ",
        ]

    private var trainWidth: Int {
        trainLines.map { $0.count }.max() ?? 0
    }
    private var trainHeight: Int {
        trainLines.count
    }

    // ANSI を書き出す簡単なヘルパ
    private func write(_ s: String) {
        FileHandle.standardOutput.write(s.data(using: .utf8)!)
    }

    /// カーソル移動（1-origin）
    private func moveCursor(row: Int, col: Int) {
        write("\u{1B}[\(row);\(col)H")
    }

    /// カーソル非表示
    private func hideCursor() {
        write("\u{1B}[?25l")
    }

    /// カーソル表示
    private func showCursor() {
        write("\u{1B}[?25h")
    }

    /// 画面全体クリア＋ホーム
    private func clearScreen() {
        write("\u{1B}[2J")   // 全消去
        write("\u{1B}[H")    // カーソルを左上へ
    }

    /// 指定行を空白でクリア
    private func clearLine(row: Int, width: Int) {
        moveCursor(row: row, col: 1)
        write(String(repeating: " ", count: max(width, 0)))
    }

    /// row: 行数, col: 列数
    func run(row rows: Int, col cols: Int) {
        // 0 行/0 列など異常値なら何もしない
        guard rows > 0, cols > 0 else { return }

        // 端末を alternate screen に切り替え（元の画面は退避）
        // Vim や less が使うやつです
        write("\u{1B}[?1049h")

        hideCursor()
        clearScreen()

        // 縦方向のセンタリング（0-origin で考える）
        // 画面: 0...(rows-1), 列車: 0...(trainHeight-1)
        let baseRow0 = max(0, (rows - trainHeight) / 2)

        // 1 フレーム前に列車が占有していた行を全部消す関数
        func clearTrainArea() {
            for i in 0..<trainHeight {
                let row0 = baseRow0 + i
                if row0 >= 0 && row0 < rows {
                    clearLine(row: row0 + 1, width: cols)
                }
            }
        }

        // 横方向は 0-origin で扱う（画面は 0...(cols-1)）
        var x = cols   // 左端が画面右端の1つ外側からスタート

        // アニメーション終了後にカーソル・画面を元に戻す
        defer {
            showCursor()
            // alternate screen を終了し、元の画面に戻す
            write("\u{1B}[?1049l")
        }

        // 列車の左端 x が trainWidth 分左に抜けるまで描画し続ける
        while x + trainWidth > 0 {
            // 古い位置を消す
            clearTrainArea()

            // 新しい位置を描画
            for (lineIndex, line) in trainLines.enumerated() {
                let lineLen = line.count
                if lineLen == 0 { continue }

                let row0 = baseRow0 + lineIndex
                if row0 < 0 || row0 >= rows { continue }

                // 列車の占有範囲 [trainLeft, trainRight]（0-origin）
                let trainLeft  = x
                let trainRight = x + lineLen - 1

                // 画面の範囲 [0, cols-1] と交差していなければ描かない
                if trainRight < 0 || trainLeft >= cols {
                    continue
                }

                // 画面上での表示範囲 [screenLeft, screenRight]（0-origin）
                let screenLeft  = max(0, trainLeft)
                let screenRight = min(cols - 1, trainRight)
                let visibleLen  = screenRight - screenLeft + 1
                if visibleLen <= 0 { continue }

                // 文字列中の開始位置（列車左端からのオフセット）
                let srcStart = screenLeft - trainLeft
                let startIdx = line.index(line.startIndex, offsetBy: srcStart)
                let endIdx   = line.index(startIdx, offsetBy: visibleLen)
                let visible  = String(line[startIdx..<endIdx])

                // ANSI は 1-origin なので +1
                moveCursor(row: row0 + 1, col: screenLeft + 1)
                write(visible)
            }

            // 少し待ってから左に 1 マス進める
            Thread.sleep(forTimeInterval: 0.06)
            x -= 1
        }
    }
}
