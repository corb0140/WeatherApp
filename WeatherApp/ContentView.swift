//
//  ContentView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isCityWeatherDetailViewActive = false

    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                CityListView(isDetailActive: $isCityWeatherDetailViewActive)
                    .environmentObject(themeManager)
                    .tabItem {
                        Label("Cities", systemImage: "building.2")
                    }
                    .tag(0)

                SearchView(selectedTab: $selectedTab)
                    .environmentObject(themeManager)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(1)

                SettingsView()
                    .environmentObject(themeManager)
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .tag(2)
            }
            .opacity(isCityWeatherDetailViewActive ? 0 : 1)
            .onAppear {
                updateTabBarAppearance(for: themeManager.isDarkMode)
            }
        }
        .padding(.top)
        .ignoresSafeArea()
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
