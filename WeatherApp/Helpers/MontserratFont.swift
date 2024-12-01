//
//  MontserratFont.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-30.
//

import SwiftUI

extension Font {
    static func montserrat(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String

        switch weight {
            case .regular:
                fontName = "Montserrat-Regular"
            case .medium:
                fontName = "Montserrat-Medium"
            case .bold:
                fontName = "Montserrat-Bold"
            default:
                fontName = "Montserrat-Regular"
        }

        return .custom(fontName, size: size)
    }
}
