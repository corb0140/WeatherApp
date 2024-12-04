//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-26.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var cityManager = CityManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environmentObject(cityManager)
//                .modelContainer(for: City.self)
        }
    }
}
