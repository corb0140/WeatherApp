//
//  ThemeManager.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-30.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = true

    init(isDarkMode: Bool = false) {
        self.isDarkMode = isDarkMode
        setDarkMode(isDarkMode)
    }

    func setDarkMode(_ isDarkMode: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
    }

    struct CustomToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .foregroundColor(configuration.isOn ? .light : .dark)
                    .frame(width: 60, height: 30)

                Image(systemName: configuration.isOn ? "sun.max.fill" : "moon.fill")
                    .foregroundColor(configuration.isOn ? .dark : .light)
                    .font(.title3)
                    .offset(x: configuration.isOn ? -15 : 15)
            }
        }
    }
}
