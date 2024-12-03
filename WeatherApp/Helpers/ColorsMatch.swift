//
//  ColorsMatch.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-12-01.
//

import SwiftUI

enum ColorsMatch {
    case cyan, blue, green, orange, red

    var color: Color {
        switch self {
        case .cyan:
            return Color.cyan.opacity(0.70)
        case .blue:
            return Color.blue.opacity(0.70)
        case .green:
            return Color.green.opacity(0.70)
        case .orange:
            return Color.orange.opacity(0.70)
        case .red:
            return Color.red.opacity(0.70)
        }
    }
}

func colorsMatch(from value: Int) -> ColorsMatch? {
    switch value {
    case ..<20:
        return .cyan
    case 20..<30:
        return .blue
    case 30..<41:
        return .green
    case 41..<61:
        return .orange
    case 61...:
        return .red
    default:
        return nil
    }
}
