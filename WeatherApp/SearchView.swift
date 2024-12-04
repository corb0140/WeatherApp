//
//  SearchView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-28.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var themeManager: ThemeManager

    @State var citiesList: [String] = []

    var body: some View {
        ZStack {
            themeManager.isDarkMode ? Color.dark : Color.light

            List(citiesList, id: \.self) { city in
                Text(city)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            Task {
                let results = try await CountryAndCityHTTPClient.asyncFetchCities()
                switch results {
                    case .success(let cities):
                        citiesList = cities.data.flatMap { $0.cities }
                    case .failure:
                        break
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
