//
//  Colors+Extension.swift
//  BetterHours
//
//  Created by MacDole on 2023/08/31.
//

import SwiftUI

extension Color {
    static func random() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}
