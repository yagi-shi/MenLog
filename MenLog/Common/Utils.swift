import Foundation
import SwiftUI
import UIKit

/*
 共通関数を格納
 */

/**
 日付をStringに変換する関数
 - parameter date: Date型の日付
 - returns: yyyy年M月d日形式の文字列
 */
func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年M月d日"
    return formatter.string(from: date)
}

/**
 extension: Font型に作成した関数を追加し拡張
 */
extension Font {
    func myGothic(size: CGFloat) -> Font {
        .system(size: size, weight: .regular)
    }
}
