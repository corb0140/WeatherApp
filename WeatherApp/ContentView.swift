//
//  ContentView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CityListView()
                .tabItem {
                    Label("Cities", systemImage: "building.2")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            AboutView()
                .tabItem {
                    Label("About", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager())
}
