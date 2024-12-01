//
//  SymbolsMatch.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-12-01.
//

import SwiftUI

enum WeatherSymbols: String {
    case clearDay = "sun.max.fill"
    case clearNight = "moon.fill"
    case cloudSun = "cloud.sun.fill"
    case cloudMoon = "cloud.moon.fill"
    case scatteredClouds = "cloud.fill"
    case rainSun = "sun.rain.fill"
    case rainMoon = "cloud.moon.rain.fill"
    case showeryRain = "cloud.heavyrain.fill"
    case thunderstorm = "cloud.bolt.rain.fill"
    case snow = "cloud.snow.fill"
    case mist = "cloud.fog.fill"
    case noSelection = "sun.max.trianglebadge.exclamationmark"
}

func symbolsMatch(from symbol: String) -> WeatherSymbols? {
    switch symbol {
        case "01d":
            return .clearDay
        case "01n":
            return .clearNight
        case "02d":
            return .cloudSun
        case "02n":
            return .cloudMoon
        case "03d", "03n", "04d", "04n":
            return .scatteredClouds
        case "10d":
            return .rainSun
        case "10n":
            return .rainMoon
        case "09d", "09n":
            return .showeryRain
        case "11d", "11n":
            return .thunderstorm
        case "13d", "13n":
            return .snow
        case "50d", "50n":
            return .mist
        default:
            return .noSelection
    }
}
