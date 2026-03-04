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
    
    final class TrainView: View {
            private var isAnimating = false
            private var animationWorkItem: DispatchWorkItem?

            // 簡易 ASCII 列車
            private let trainLines: [String] = [
                "      ____      ",
                " ___/|__|\\___   ",
                "|_o_o_o_o_o_|   "
            ]

            private let trainWidth: Int
            private let trainHeight: Int

            // 列車の左端 X 座標
            private var currentX: Int

            /// 端末の横幅（何列あるか）を渡す
        init(terminalWidth: Int, terminalHeight: Int) {
                self.trainHeight = trainLines.count
                self.trainWidth  = trainLines.map { $0.count }.max() ?? 0
                // 画面のすぐ右側から出てくるようにする
                self.currentX    = terminalWidth
                super.init()
                fill()
                canFocus = false
            }

            deinit {
                stopAnimation()
            }

            // 画面中央付近に列車を描画
            override func drawContent(in region: Rect, painter: Painter) {
                let viewWidth  = bounds.width
                let viewHeight = bounds.height

                let baseY = max(0, (viewHeight - trainHeight) / 2)

                for (row, line) in trainLines.enumerated() {
                    let lineLen = line.count
                    if lineLen == 0 { continue }

                    let drawY = baseY + row
                    if drawY < 0 || drawY >= viewHeight { continue }

                    // 列車の表示範囲 [left, right)
                    let left  = currentX
                    let right = currentX + lineLen

                    // 完全に画面外ならスキップ
                    if right <= 0 || left >= viewWidth { continue }

                    // 画面上の表示区間 [visibleStartScreen, visibleEndScreen)
                    let visibleStartScreen = max(left, 0)
                    let visibleEndScreen   = min(right, viewWidth)
                    let visibleLen         = visibleEndScreen - visibleStartScreen
                    if visibleLen <= 0 { continue }

                    // 文字列中の開始位置（列車左端からのオフセット）
                    let srcStart = visibleStartScreen - left

                    let startIdx = line.index(line.startIndex, offsetBy: srcStart)
                    let endIdx   = line.index(startIdx, offsetBy: visibleLen)
                    let visible  = String(line[startIdx..<endIdx])

                    painter.goto(col: visibleStartScreen, row: drawY)
                    painter.add(str: visible)
                }
            }

            override func positionCursor() {
                if let parent = superview {
                    parent.moveTo(col: 0, row: 0)
                } else {
                    moveTo(col: 0, row: 0)
                }
            }

            func startAnimation() {
                guard !isAnimating else { return }
                isAnimating = true
                scheduleNextFrame()
            }

            private func stopAnimation() {
                isAnimating = false
                animationWorkItem?.cancel()
                animationWorkItem = nil
            }

            private func scheduleNextFrame() {
                let workItem = DispatchWorkItem { [weak self] in
                    guard let self = self, self.isAnimating else { return }
                    self.stepFrame()
                    if self.isAnimating {
                        self.scheduleNextFrame()
                    }
                }
                animationWorkItem = workItem
                // 約 40ms 間隔
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: workItem)
            }

            private func stepFrame() {
                currentX -= 1

                // 完全に画面左側へ抜けたら終了
                if currentX + trainWidth < 0 {
                    stopAnimation()
                    Application.requestStop()
                    return
                }

                setNeedsDisplay()
            }
        }

    
    /// 貨物車両
    static let cargo = Cargo.default
    
    func run(row: Int, col: Int) {
        Application.prepare()
        let win = Window()
        win.x = Pos.at(0)
        win.y = Pos.at(0)
        win.width = Dim.fill()
        win.height = Dim.fill()

        // 列車を描画・アニメーションする View
        let trainView = TrainView(terminalWidth: col, terminalHeight: row)
        trainView.fill()

        win.addSubview(trainView)
        Application.top.addSubview(win)

        // アニメーション開始
        trainView.startAnimation()

        // メインループ
        Application.run()
    }
}
