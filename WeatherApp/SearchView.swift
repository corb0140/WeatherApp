//
//  SearchView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-28.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack {
            themeManager.isDarkMode ? Color.dark : Color.light
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SearchView()
}
