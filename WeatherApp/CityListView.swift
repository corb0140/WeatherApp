//
//  CityListView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-28.
//

import SwiftUI

struct CityListView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack(alignment: .topTrailing) {
            themeManager.isDarkMode ? Color.white : Color.black

            ThemeChangeView()
                .offset(x: -30, y: 50)
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.8), value: themeManager.isDarkMode)
    }
}

#Preview {
    CityListView()
        .environmentObject(ThemeManager())
}
