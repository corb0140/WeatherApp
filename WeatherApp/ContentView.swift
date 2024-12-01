//
//  ContentView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        TabView {
            CityListView()
                .environmentObject(themeManager)
                .tabItem {
                    Label("Cities", systemImage: "building.2")
                }

            SearchView()
                .environmentObject(themeManager)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            SettingsView()
                .environmentObject(themeManager)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            AboutView()
                .environmentObject(themeManager)
                .tabItem {
                    Label("About", systemImage: "person.fill")
                }
        }
        .onAppear {
            updateTabBarAppearance(for: themeManager.isDarkMode)
        }
    }

    func updateTabBarAppearance(for isDarkMode: Bool) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = isDarkMode ? .dark : .light
        appearance.stackedLayoutAppearance.normal.iconColor = isDarkMode ? .light : .dark
        appearance.stackedLayoutAppearance.selected.iconColor = .blue

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager())
}
